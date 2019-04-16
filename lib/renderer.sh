renderer() {
  [ -n "${viz_dot_file-}" ] || __error__ 'must set viz_dot_file, the main viz dot file.'
  [ -n "${gvpr_tree_util-}" ] || __error__ 'must set gvpr_tree_util, the GVPR tree util dot file.'
  [ -n "${final_output_format-}" ] || __error__ 'must set final_output_format, the final output format.'
  [ -n "${output_file-}" ] || __error__ 'must set output_file, the output file.'

  if [ -n "${__docker__-}" ]; then
    if dot "$viz_dot_file" |
      gvpr -c -f "$gvpr_tree_util" |
      neato -n -T "$final_output_format" -o "$output_file"; then
      feh "$output_file"
    fi
  else
    if dot "$viz_dot_file" |
      gvpr -c -f "$gvpr_tree_util" |
      neato -n -T "$final_output_format" -o "$output_file"; then
      xviewer "$output_file" &
    fi
  fi
}

__error__() {
  local msg="${1-}"

  echo "ERROR: $msg" >&2
  exit 1
}

set -o nounset
renderer "$@"
