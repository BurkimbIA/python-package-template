# display help information
default:
    @just --list


# clean the project
clean:
    rm -rf .venv/


# install the dependencies
install:
    uv sync --all-groups


# format with ruff
format:
    uv tool run ruff format
# lint with ruff
lint:
    uv tool run ruff check
