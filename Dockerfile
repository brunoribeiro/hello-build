FROM rustlang/rust:nightly AS build

WORKDIR /usr/src/app
COPY Cargo.toml .
COPY src/ src/
RUN cargo build --release

FROM debian:stretch AS package

COPY --from=build /usr/src/app/target/release/hello_build /usr/local/src/

EXPOSE 8000

ENV ROCKET_ADDRESS="0.0.0.0"

CMD ["/usr/local/src/hello_build"]