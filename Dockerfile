FROM rustlang/rust:nightly AS build

WORKDIR /usr/src/app

# Build deps
COPY Cargo.toml .
RUN mkdir -p src && echo > src/main.rs "fn main() {}"
RUN cargo build --release

# Build app
COPY src/ src/
RUN cargo build --release

FROM debian:stretch AS package

COPY --from=build /usr/src/app/target/release/hello_build /usr/local/src/

EXPOSE 8000

ENV ROCKET_ADDRESS="0.0.0.0"

CMD ["/usr/local/src/hello_build"]