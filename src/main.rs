use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};
use md5;
use redis::{Client, Commands, Connection};
use std::io::Result;

// 服务状态
#[get("/status")]
async fn status() -> impl Responder {
    HttpResponse::Ok().body("App Online!")
}

// 缩短链接
#[post("/s")]
async fn s(url: String, client: web::Data<Client>) -> impl Responder {
    println!("url:{}", url);
    // 生成短链
    let smd5 = format!("{:x}", md5::compute(&url));
    let short = smd5[0..8].to_string();
    let surl = format!("http://127.0.0.1:8080/{}", short);
    // 写入 redis
    set_data(&client, &short, &url).unwrap();
    HttpResponse::Ok().body(surl)
}

// 重定向短链
#[get("/{s}")]
async fn r(short: web::Path<String>, client: web::Data<Client>) -> impl Responder {
    println!("short:{}", &short);
    // 读取 redis
    let url = get_data(&client, &short);
    let rurl = match url {
        Ok(surl) => surl,
        Err(_) => "http://127.0.0.1:8080/status".to_string(),
    };
    // 重定向
    HttpResponse::MovedPermanently()
        .append_header(("Location", rurl))
        .finish()
}

// 主程序入口
#[actix_web::main]
async fn main() -> Result<()> {
    // redis 客户端
    let client = redis::Client::open("redis://127.0.0.1:6379/").unwrap();
    // 启动服务
    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(client.clone()))
            .service(status)
            .service(s)
            .service(r)
    })
    .bind(("127.0.0.1", 8080))?
    .run()
    .await
}

// 写入数据
fn set_data(cli: &Client, key: &str, value: &str) -> redis::RedisResult<()> {
    let mut con = cli.get_connection()?;
    con.set(key, value)
}

// 读取数据
fn get_data(cli: &Client, key: &str) -> redis::RedisResult<String> {
    let mut con = cli.get_connection()?;
    con.get(key)
}
