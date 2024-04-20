_default:
    @just --list --unsorted

HERE           := justfile_directory()
COMPOSE_FILE   := HERE / "docker-compose.yml"
DOCKER_COMPOSE := "docker compose --file " + COMPOSE_FILE

set dotenv-load

create_volumes:
    #!/usr/bin/env bash
    set -euo pipefail
    VOLUMES=("sigint.in_caddy_config" "sigint.in_caddy_data")
    for volume in "${VOLUMES[@]}";
    do
        echo -n "[*] Volume '$volume' "
        # "--format json" is just to remove the table header the default template shows :P
        vol_info=$(docker volume ls -f name=$volume --format json | awk '{print $NF}')
        if [ $vol_info ]
        then
            echo "already exists"
        else
            echo "does not exist. Creating..."
            docker volume create $volume
        fi
    done

init: create_volumes
    {{DOCKER_COMPOSE}} up --detach

compose *ARGS:
    {{DOCKER_COMPOSE}} {{ARGS}}

jekyll *ARGS:
    -{{DOCKER_COMPOSE}} exec -t jekyll bash -c "{{ARGS}}"

@compile: clean
    #!/usr/bin/env bash
    set -euo pipefail
    cp -r {{HERE}}/src/posts/* {{HERE}}/jekyll/_posts/
    cp -r {{HERE}}/src/assets/{css,images} {{HERE}}/jekyll/assets/
    cp -r {{HERE}}/src/assets/sass/* {{HERE}}/jekyll/_sass/
    find {{HERE}}/src/ -maxdepth 1 -type f -exec cp -t {{HERE}}/jekyll/ {} +
    just jekyll "jekyll build" && \
        cp -r {{HERE}}/jekyll/_site/* {{HERE}}/server/root/ && \
        echo "Done"

@clean:
    #!/usr/bin/env bash
    set -euo pipefail
    rm --recursive --force {{HERE}}/jekyll/{_posts,_sass,_site,assets,.jekyll-cache}/*
    rm --recursive --force {{HERE}}/jekyll/.jekyll-cache
    touch {{HERE}}/jekyll/{_posts,_sass,_site,assets}/.keep
    rm --recursive --force {{HERE}}/server/root/*
    find {{HERE}}/src -maxdepth 1 -type f -printf "%f\n" |  \
        xargs -I% rm --force {{HERE}}/jekyll/%
