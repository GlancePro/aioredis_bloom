PYTHON ?= python3
FLAKE ?= pyflakes
PEP ?= pep8

.PHONY: all flake doc test cov
all: flake doc cov

doc:
	make -C docs html

flake:
	$(FLAKE) aioredis_bloom tests examples
	$(PEP) aioredis_bloom tests examples

test:
	$(PYTHON) runtests.py -v

cov coverage:
	$(PYTHON) runtests.py --coverage

clean:
	find . -name __pycache__ |xargs rm -rf
	find . -type f -name '*.py[co]' -delete
	find . -type f -name '*~' -delete
	find . -type f -name '.*~' -delete
	find . -type f -name '@*' -delete
	find . -type f -name '#*#' -delete
	find . -type f -name '*.orig' -delete
	find . -type f -name '*.rej' -delete
	rm -f .coverage
	rm -rf coverage
	rm -rf docs/_build