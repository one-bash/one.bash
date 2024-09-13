usage() {
	# editorconfig-checker-disable
	cat <<EOF
Usage: one repo search [OPTIONS] [<WORD>]

Desc:  Search Top 100 repos (topic: one-bash-repo) in Github
       This command requires jq. https://github.com/jqlang/jq

Arguments:
  <WORD>                 Any word to search repo name. If omit, search all repos.

Options:
  --token <TOKEN>        Github token. It's optional
EOF
	# editorconfig-checker-enable
}

completion() {
	echo '--token'
}

declare -A opts=()
declare -a args=()

main() {

	if l.has_not command jq; then
		print_err 'This command requires jq. https://github.com/jqlang/jq'
		return "$ONE_EX_SOFTWARE"
	fi

	local -a curl_opts=(
		-fsSL
		-H "Accept: application/vnd.github+json"
		-H "X-GitHub-Api-Version: 2022-11-28"
	)

	if [[ -n ${opts[token]:-} ]]; then
		curl_opts+=(
			-H "Authorization: Bearer ${opts[token]}"
		)
	fi

	printf "Searching..."

	local q="topic:one-bash-repo"
	local word=${args[0]:-}
	if [[ $word ]]; then
		q="$q%20${word// /%20}"
	fi
	local url="https://api.github.com/search/repositories?q=$q&per_page=100&%20"
	local content name desc stars line
	curl "${curl_opts[@]}" "$url" |
		jq -c '.items | sort_by(-.stargazers_count) | .[] | {full_name, stargazers_count, description}' | {
		printf '\033[2K\033[0G' # Clean Searching...
		printf '%-30s %-8s %s\n' 'Name' 'Stars' 'Description'

		while read -r line; do
			if [[ $line =~ \{\"full_name\":\"([^\"]+)\",\"stargazers_count\":([0-9]+),\"description\":\"([^\"]+)\"\} ]]; then
				name="${BASH_REMATCH[1]}"
				stars="${BASH_REMATCH[2]}"
				desc="${BASH_REMATCH[3]}"
				printf '%-30s %-8s %s\n' "$name" "$stars" "$desc"
			fi
		done
	}
	# name=$(grep '"full_name"' <<<"$content" | sed -E 's/[^:]+: "(.+)",/\1/')
	# desc=$(grep '""' <<<"$content" | sed -E 's/[^:]+: "(.+)",/\1/')
	# stars=$(grep '"stargazers_count"' <<<"$content" | sed -E 's/[^:]+: (.+),/\1/')

}
