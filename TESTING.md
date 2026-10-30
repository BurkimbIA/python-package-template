# Testing Guidelines

Testing policy for this repository. Read it, together with [`AGENTS.md`](AGENTS.md), before writing or reviewing tests.

## Running the tests

```bash
just test                           # uv run pytest
uv run pytest tests/test_my_package.py -k main
```

- Tests run locally, without a GPU, cloud services or credentials. They must stay that way: code paths that need those are tested up to the boundary (see [Fakes and mocks](#fakes-and-mocks)).
- `filterwarnings = error` (except `UserWarning` / `DeprecationWarning`): a new warning fails the tests. Fix the cause rather than adding an ignore.

## Core rule

A test must fail when behavior is wrong. It should not fail only because an implementation detail, wording choice, helper call, or argument assembly changed.

It is better to have no test than a "slop" test (tautological or otherwise useless, see below).

Prefer tests through the public functions that check what a user or a downstream caller observes:

- returned values
- files written to `tmp_path`
- round trips: save then reload, serialize then parse
- computed values against an independent reference

## Good targets

- A regression for a reported bug or a fixed issue. Say in the docstring what went wrong.
- A boundary case where behavior changes: empty or mismatched inputs, missing fields, unknown values.
- A stable contract that other code or people consume: output file names and their fields, serialized formats, public API results.
- Compatibility with breaking renames listed in `CHANGELOG.md`.
- A change of behavior in a dependency we rely on.

## Slop tests to reject

Delete or rewrite tests with negative value:

- **Tautologies**: a constant equals itself, a function exists, a constructor assigns its arguments, `isinstance(result, DataFrame)` when the result is the mocked return value. Construe this broadly.
- **Configuration projections**: asserting a field equals the value the test (or a checked-in config file) just set.
- **Defaults**: asserting the default of a scalar or list. Test what the default enables instead.
- **Private state**: assertions on `_`-prefixed attributes or functions.
- **Internal dispatch**: `assert_called_once_with`, `call_count`, or "helper X was invoked" for functions of this repo.
- **Reimplementation**: a test that recomputes the result with the same code it tests.
- **Weak assertions that pass when behavior is wrong**: "different seeds" without checking the outputs differ, `0 <= score <= 100`, "column exists" when the input already had it.
- **Scalar and configuration guards**: a test that only sets an unknown enum value or an out-of-range number and checks construction raises. Keep one only for a reported regression, a CHANGELOG breaking rename, or a check whose point is to fail before an expensive run that would otherwise fail (or silently be wrong) at the end.
- **Incidental strings**: log messages, progress text, or loose substrings of prose.
- Tests for the semantics of Python or a third-party library.
- Registration tests: a name maps to a specific function in a registry. Test the behavior through the name instead.
- Duplicates of a test in another file.
- Permanently skipped tests or empty test files.
- "Does not raise" tests without a comment explaining why that is the contract.
- `pytest.raises` without `match=` when the exception type alone isn't the contract.

During development, use scratch scripts, a REPL, or a notebook to check imports, construction or fixture wiring. Don't leave those as pytest tests.

String assertions are allowed when the string is the contract: file names, JSON fields, generated text consumed by another system, and the error messages users act on.

## Fakes and mocks

Default to real behavior: real data structures, real libraries, local files in `tmp_path`.

Mock or fake only at the boundaries tests can't cross:

| Boundary | How |
| --- | --- |
| Remote APIs and cloud storage | monkeypatch with a function returning a small real value; it may record the path and credentials it was given, since that is the wire contract |
| Hardware (GPU) and heavy model loading | a fake object returning fixed outputs |
| Experiment tracking and telemetry | monkeypatch the client's logging calls |
| Environment variables | `monkeypatch.setenv` / `delenv`, never patching `os.environ.get` |

Prefer fakes that record state over mocks. Don't mock functions of this repo to prove wiring; if that seems necessary, test the behavior one level up or reconsider the API.

## Timing

Don't use `time.sleep()` in tests. To test timing outputs, pass the durations as inputs.

## Numerical tests

- Don't relax tolerances (`pytest.approx`, thresholds) without the user's agreement.

## Review checklist

Flag the test if the answer to any question is "yes":

- Would this test pass if the behavior were wrong?
- Would it fail only because a helper was renamed, a log line changed or an internal call changed?
- Does it assert on private state, call counts or internal dispatch?
- Does it duplicate the implementation instead of checking an independent oracle or observable output?
- Does it only mirror a config guard, a default, or a value the test itself set?
- Is the mock inside the system under test rather than at an external boundary?
- Does it need a GPU, cloud services or credentials?
- Does it sleep, skip permanently, or lack a real assertion?
- Did the change weaken a tolerance or an expectation without justification?

Ask for low-value tests to be deleted or rewritten. More tests are not better when they pin implementation details and miss real regressions.
