#!/bin/sh

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

TEMP_PATH="$(mktemp -d)"
PATH="${TEMP_PATH}:$PATH"
export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"
MARKUPLINT_FORMATTER="${GITHUB_ACTION_PATH}/markuplint-formatter-rdjson/index.js"

echo '::group::🐶 Installing reviewdog ... https://github.com/reviewdog/reviewdog'
curl -sfL https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh | sh -s -- -b "${TEMP_PATH}" "${REVIEWDOG_VERSION}" 2>&1
echo '::endgroup::'

npx --no-install -c 'markuplint --version'
if [ $? -ne 0 ]; then
  echo '::group:: Running `npm install` to install markuplint ...'
  set -e
  npm install
  set +e
  echo '::endgroup::'
fi

echo "markuplint version:$(npx --no-install -c 'markuplint --version')"

echo '::group:: Running markuplint with reviewdog 🐶 ...'
npx --no-install -c "markuplint ${INPUT_MARKUPLINT_TARGETS} -f JSON ${INPUT_MARKUPLINT_FLAGS:-'.'}" \
  | node "${MARKUPLINT_FORMATTER}" \
  | reviewdog -f=rdjson \
      -name="markuplint" \
      -reporter="${INPUT_REPORTER:-github-pr-review}" \
      -filter-mode="${INPUT_FILTER_MODE}" \
      -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
      -level="${INPUT_LEVEL}" \
      ${INPUT_REVIEWDOG_FLAGS}

reviewdog_rc=$?
echo '::endgroup::'
exit $reviewdog_rc
