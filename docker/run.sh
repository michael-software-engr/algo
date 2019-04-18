docker_run() {
  local ruby_file="${1?:ERROR, must pass Ruby file to run.}"
  local root_dir="$(dirname "$(readlink -f "$BASH_SOURCE")")"

  local context_dir_bname='dev'
  local context_dir="./docker/$context_dir_bname"

  local templates_dir="$root_dir/templates"

  local dcbname='docker-compose.yml'
  local docker_compose_file="$context_dir/$dcbname"

  local docker_xauth=/tmp/.docker.xauth
  xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $docker_xauth nmerge -

  local epbname='entrypoint.sh'
  local entrypoint="$context_dir/$epbname"

  [ -d "$context_dir" ] || mkdir -p "$context_dir" || exit

  local dfbname='Dockerfile'
  local dockerfile="$context_dir/$dfbname"

  generate_entry_point_file \
    "$templates_dir/$epbname" \
    "$entrypoint" \
    "$ruby_file"

  check_required_files \
    "$docker_compose_file" \
    "$dockerfile" \
    "$entrypoint"

  # Needed for the docker-compose config file below.
  export xviewer_package='feh'
  export dockerfile="$dockerfile"
  export xsock='/tmp/.X11-unix'
  export docker_xauth="$docker_xauth"
  export docker_uid="$UID"
  export docker_user='dev'
  export entrypoint="$entrypoint"

  docker-compose \
    --file "$docker_compose_file" \
    build || exit

  docker-compose --file "$docker_compose_file" up
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
