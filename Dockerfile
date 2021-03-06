FROM rustlang/rust:nightly AS build

WORKDIR /usr/src/app

# Build deps
COPY Cargo.toml .
RUN mkdir -p src && echo > src/main.rs "fn main() { println!(\"I shouldn't be here :(\"); }"
RUN cargo build --release

# Build app
COPY src/ src/
# cargo seems to skip build according to timestamp...
RUN touch src/* && cargo build --release

FROM debian:stretch AS package

COPY --from=build /usr/src/app/target/release/hello_build /usr/local/bin/

EXPOSE 8000

ENV ROCKET_ADDRESS="0.0.0.0"

CMD ["/usr/local/bin/hello_build"]