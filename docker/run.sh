docker_run() {
  local ruby_file="${1?:ERROR, must pass Ruby file to run.}"
  local root_dir="$(dirname "$(readlink -f "$BASH_SOURCE")")"

  local context_dir_bname='dev'
  local context_dir="./docker/$context_dir_bname"

  local templates_dir="$root_dir/templates"

  local dcbname='docker-compose.yml'
  local docker_compose_template="$templates_dir/$dcbname"
  local docker_compose_file="$context_dir/$dcbname"

  local docker_xauth=/tmp/.docker.xauth
  xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $docker_xauth nmerge -

  local epbname='entrypoint.sh'
  local entrypoint="$context_dir/$epbname"

  generate_docker_compose_file \
    "$docker_compose_template" \
    "$docker_compose_file" \
    "$context_dir" \
    "$entrypoint" \
    "$docker_xauth"

  generate_entry_point_file \
    "$templates_dir/$epbname" \
    "$entrypoint" \
    "$ruby_file"

  check_required_files "$root_dir" "$docker_compose_file"

  docker-compose \
    --file "$docker_compose_file" \
    build || exit

  docker-compose --file "$docker_compose_file" up
}

generate_docker_compose_file() {
  local docker_compose_template="${1?:ERROR, must pass docker-compose.yml template path.}"
  local docker_compose_template_target="${2?:ERROR, must pass docker-compose.yml dest path.}"
  local context_dir="${3?:ERROR, must pass context dir path.}"
  local entrypoint="${4?:ERROR, must pass entry point path.}"
  local docker_xauth="${5?:ERROR, must pass Docker XAUTHORITY path.}"

  xviewer_package='feh' \
  dockerfile="$context_dir/Dockerfile" \
  xsock='/tmp/.X11-unix' \
  docker_xauth="$docker_xauth" \
  docker_uid="$UID" \
  docker_user='dev' \
  entrypoint="$entrypoint" \
    envsubst < "$docker_compose_template" > "$docker_compose_template_target" || exit
}

generate_entry_point_file() {
  local template_file="${1?:ERROR, must pass entry point template path.}"
  local entrypoint="${2?:ERROR, must pass entry point path.}"
  local ruby_file="${3?:ERROR, must mass Ruby file to run.}"

  ruby_file="$ruby_file" envsubst < "$template_file" > "$entrypoint" || exit
  chmod 755 "$entrypoint"
}

check_required_files() {
  local root_dir="${1?:ERROR, must pass root dir.}"
  shift

  declare -a files_under_config=(
    "$root_dir/dev/Dockerfile"
  )

  local file=''
  for file in "${files_under_config[@]}" "$@"; do
    [ -f "$file" ] || __error__ "required file '$file' not found."
  done
}

__error__() {
  local msg="$1"

  echo "ERROR: $msg" >&2
  exit 1
}

set -o nounset
docker_run "$@"
