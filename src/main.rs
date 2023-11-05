use actix_web::{get, post, web, App, HttpResponse, HttpServer, Responder};

// 服务状态
#[get("/status")]
async fn status() -> impl Responder {
    HttpResponse::Ok().body("App Online!")
}

// 缩短链接
#[post("/s")]
async fn s(url: String) -> impl Responder {
    println!("url:{}", url);
    HttpResponse::Ok().body(url)
}

// 重定向短链
#[get("/r/{s}")]
async fn r(surl: web::Path<String>) -> impl Responder {
    println!("surl:{}", surl);
    HttpResponse::MovedPermanently()
        .append_header(("Location", "https://www.baidu.com"))
        .finish()
}

// 主程序入口
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| App::new().service(status).service(s).service(r))
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}
