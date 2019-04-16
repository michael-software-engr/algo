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

  [ -d "$context_dir" ] || mkdir -p "$context_dir" || exit

  local dfbname='Dockerfile'
  local dockerfile="$context_dir/$dfbname"
  generate_docker_compose_file \
    "$docker_compose_template" \
    "$docker_compose_file" \
    "$dockerfile" \
    "$entrypoint" \
    "$docker_xauth" \
    "$dfbname"

  generate_docker_file "$templates_dir" "$dockerfile" "$dfbname"

  generate_entry_point_file \
    "$templates_dir/$epbname" \
    "$entrypoint" \
    "$ruby_file"

  check_required_files \
    "$docker_compose_file" \
    "$dockerfile" \
    "$entrypoint"

  docker-compose \
    --file "$docker_compose_file" \
    build || exit

  docker-compose --file "$docker_compose_file" up
}

generate_docker_compose_file() {
  local docker_compose_template="${1?:ERROR, must pass docker-compose.yml template path.}"
  local docker_compose_template_target="${2?:ERROR, must pass docker-compose.yml dest path.}"
  local dockerfile="${3?:ERROR, must pass Dockerfile path.}"
  local entrypoint="${4?:ERROR, must pass entry point path.}"
  local docker_xauth="${5?:ERROR, must pass Docker XAUTHORITY path.}"

  xviewer_package='feh' \
  dockerfile="$dockerfile" \
  xsock='/tmp/.X11-unix' \
  docker_xauth="$docker_xauth" \
  docker_uid="$UID" \
  docker_user='dev' \
  entrypoint="$entrypoint" \
    envsubst < "$docker_compose_template" > "$docker_compose_template_target" || exit
}

generate_docker_file() {
  local templates_dir="${1?:ERROR, must pass templates dir path.}"
  local dockerfile="${2?:ERROR, must pass context dir path.}"
  local dfbname="${3?:ERROR, must pass Dockerfile base name.}"

  # Copy for now. envsubst will replace $variables with nothing. But we're
  #   injecting env variables through docker-compose.
  /bin/cp "$templates_dir/$dfbname" "$dockerfile"
  # envsubst < "$templates_dir/$dfbname" > "$dockerfile" || exit
}

generate_entry_point_file() {
  local template_file="${1?:ERROR, must pass entry point template path.}"
  local entrypoint="${2?:ERROR, must pass entry point path.}"
  local ruby_file="${3?:ERROR, must mass Ruby file to run.}"

  ruby_file="$ruby_file" envsubst < "$template_file" > "$entrypoint" || exit
  chmod 755 "$entrypoint"
}

check_required_files() {
  local file=''
  for file in "$@"; do
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
