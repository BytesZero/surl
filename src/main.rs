use std::env;

use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use dotenvy::dotenv;
use r2d2::Pool;
use redis::{Client, Commands};

// 服务状态
#[get("/status")]
async fn status() -> impl Responder {
    HttpResponse::Ok().body("Hi==>Online")
}

// 缩短链接
#[post("/s")]
async fn s(
    url: String,
    client: web::Data<Pool<Client>>,
    app_state: web::Data<AppState>,
) -> impl Responder {
    // 判断空
    if url.is_empty() {
        return HttpResponse::BadRequest().body("param is empty");
    }
    // 生成短链
    let smd5 = format!("{:x}", md5::compute(&url));
    let short = smd5[0..8].to_string();
    let surl = format!("{}/{}", app_state.host_url, short);
    // 写入 redis
    set_data(&client, &short, &url).unwrap();
    HttpResponse::Ok().body(surl)
}

// 重定向短链
#[get("/{s}")]
async fn r(
    short: web::Path<String>,
    client: web::Data<Pool<Client>>,
    app_state: web::Data<AppState>,
) -> impl Responder {
    // 判断空
    if short.is_empty() {
        return HttpResponse::NotFound().body("404 Not Found");
    }
    // 读取 redis
    let url = get_data(&client, &short);
    let rurl = match url {
        Ok(surl) => surl,
        Err(_) => format!("{}/status", app_state.host_url),
    };
    // 重定向
    HttpResponse::MovedPermanently()
        .append_header(("Location", rurl))
        .finish()
}

// 全局状态
struct AppState {
    host_url: String,
}

// 主程序入口
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    // 获取配置
    dotenv().ok();
    // 获取 host 配置
    let host_url = env::var("HOST_URL").expect("HOST_URL 必须设置");
    // 获取 redis 配置
    let redis_url = env::var("REDIS_URL").expect("REDIS_URL 必须设置");
    // redis 链接池
    let client = redis::Client::open(redis_url).unwrap();
    let pool = r2d2::Pool::builder().max_size(100).build(client).unwrap();
    // 启动服务
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(pool.clone()))
            .app_data(web::Data::new(AppState {
                host_url: host_url.clone(),
            }))
            .service(status)
            .service(s)
            .service(r)
    })
    .bind(("0.0.0.0", 8082))?
    .workers(2)
    .run()
    .await
}

// 写入数据
fn set_data(cli: &Pool<Client>, key: &str, value: &str) -> redis::RedisResult<()> {
    let mut con = cli.get().unwrap();
    con.set(key, value)
}

// 读取数据
fn get_data(cli: &Pool<Client>, key: &str) -> redis::RedisResult<String> {
    let mut con = cli.get().unwrap();
    con.get(key)
}
