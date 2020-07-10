SHELL=/bin/bash
LINT_PATHS=stable_baselines3/ tests/ docs/conf.py setup.py

pytest:
	./scripts/run_tests.sh

type:
	pytype

lint:
	# stop the build if there are Python syntax errors or undefined names
	# see https://lintlyci.github.io/Flake8Rules/
	flake8 ${LINT_PATHS} --count --select=E9,F63,F7,F82 --show-source --statistics
	# exit-zero treats all errors as warnings.
	flake8 ${LINT_PATHS} --count --exit-zero --statistics

format:
	# Sort imports
	isort stable_baselines3/ tests/ docs/conf.py
	# Reformat using black
	black -l 127 stable_baselines3/ setup.py tests/ docs/conf.py

check-codestyle:
	# Sort imports
	isort --check stable_baselines3/ tests/ docs/conf.py
	# Reformat using black
	black --check -l 127 stable_baselines3/ setup.py tests/ docs/conf.py

doc:
	cd docs && make html

spelling:
	cd docs && make spelling

clean:
	cd docs && make clean

# Build docker images
# If you do export RELEASE=True, it will also push them
docker: docker-cpu docker-gpu

docker-cpu:
	./scripts/build_docker.sh

docker-gpu:
	USE_GPU=True ./scripts/build_docker.sh

# PyPi package release
release:
	python setup.py sdist
	python setup.py bdist_wheel
	twine upload dist/*

# Test PyPi package release
test-release:
	python setup.py sdist
	python setup.py bdist_wheel
	twine upload --repository-url https://test.pypi.org/legacy/ dist/*

.PHONY: clean spelling doc lint format check-codestyle
