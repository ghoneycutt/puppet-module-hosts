# AGENTS.md

Guidance for AI agents (and new contributors) working on this Puppet module.

## What this is

A Puppet module managing /etc/hosts entries via the host resource type
(puppetlabs/host_core). It runs on the OpenVox / Vox Pupuli ecosystem, not
Puppet Labs / Perforce tooling.

## Toolchain rules

- Use OpenVox and Vox Pupuli tooling, never the Puppet Labs equivalents:
  the `openvox` gem (selected via `OPENVOX_GEM_VERSION`), `openfact`,
  `voxpupuli-test`, `voxpupuli-acceptance`, `voxpupuli-rubocop`,
  `openvox-strings`, `beaker_puppet_helpers`. The `puppet` and `facter`
  gems must never appear in `Gemfile.lock`.
- PDK is not used. Do not suggest `pdk update` or pdk-templates.
- Acceptance tests install `openvox-agent` from the Vox Pupuli repositories
  (`BEAKER_PUPPET_COLLECTION`, openvox8 or openvox9) into Docker containers
  defined by `spec/acceptance/nodesets/*.yml`.

## Commands

```sh
bundle install
bundle exec rake parallel_spec        # full unit suite
bundle exec rake check:git_ignore check:dot_underscore check:test_file \
  rubocop syntax lint metadata_lint   # the CI validate chain
BEAKER_set=el9 bundle exec rake beaker  # acceptance (needs Docker)
```

Use the same Ruby version CI uses; see `ruby-version` in
`.github/workflows/ci.yaml` (the OpenVox 9 jobs run Ruby 4.0, matching the
Ruby bundled with openvox-agent 9). RVM is the suggested way to install and
manage it. A UTF-8 locale is required: `export LC_ALL=en_US.UTF-8` or
`metadata_lint` fails with an encoding error.

## Conventions

- **This module has no platform specific logic**: it wraps the host
  resource type, which behaves identically everywhere. Because of that, the
  unit specs deliberately test a single pinned OS, metadata lists operating
  systems without release versions, and acceptance runs on one platform
  (el9); testing more would burn resources without adding coverage.
- **RuboCop**: config is inherited from the `voxpupuli-rubocop` gem;
  pre-existing offenses are grandfathered in `.rubocop_todo.yml`. Never run
  mass autocorrects over existing code; style churn destroys git history and
  breaks open pull requests. New code must comply.
- **100% resource coverage is enforced** (`RSpec::Puppet::Coverage.report!(100)`).
- Pull requests are typically a single commit; amend rather than stacking
  fixup commits. Preserve original authorship when rebasing contributor
  commits and add co-authors via `Co-Authored-By` trailers.
- `voxpupuli-test` and `voxpupuli-rubocop` versions are pinned in lockstep
  (both pin the same rubocop line); bump them together.
- **ASCII only.** Never use em dashes, smart quotes, or other non-ASCII
  characters in any file in this repo; use plain ASCII punctuation instead.
  Multibyte strings in spec/ used as test input vectors are deliberate test
  data that verifies unicode handling, and must be kept.

## Gotchas

- If facterdb has no facts for a declared platform, `on_supported_os` yields
  nothing and that platform's tests are **silently skipped**. After changing
  the pinned spec platform, confirm the example count did not drop to zero.
- Local variables assigned only inside removed `when` branches cause
  `NameError` at spec load; check them when editing platform case statements.
