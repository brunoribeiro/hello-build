#![feature(plugin)]
#![plugin(rocket_codegen)]

extern crate rocket;

#[get("/")]
fn hello() -> &'static str {
    "Hello, world! Here's a number: 42"
}

fn main() {
    rocket::ignite().mount("/", routes![hello]).launch();
}
