aioredis_bloom with redis pipeline support
==============
Forked from https://github.com/jettify/aioredis_bloom


Basic api:
----------
.. code:: python

    import asyncio
    import aioredis
    from aioredis_bloom import BloomFilter


    loop = asyncio.get_event_loop()


    @asyncio.coroutine
    def go():
        redis = yield from aioredis.create_redis(
            ('localhost', 6379), loop=loop)
        capacity = 100000  # expected capacity of bloom filter
        error_rate = 0.0001  # expected error rate
        # size of underlying array is calculated from capacity and error_rate
        bloom = BloomFilter(redis, 100000, 0.0001)
        keys = ['python', 'asyncio', 'foo']
        yield from bloom.add_keys(keys)
        result = yield from bloom.contains_keys(['tornado'])
        assert result == [False]

        redis.close()
    loop.run_until_complete(go())

Intersection and union of two bloom filters:
--------------------------------------------

Intersection and union of filters requires both filters to have
both the same capacity and error rate.

.. code:: python

    import asyncio
    import aioredis
    from aioredis_bloom import BloomFilter


    loop = asyncio.get_event_loop()


    @asyncio.coroutine
    def go():
        redis = yield from aioredis.create_redis(
            ('localhost', 6379), loop=loop)

        bloom1 = BloomFilter(redis, 1000, 0.001, 'bloom:1')
        bloom2 = BloomFilter(redis, 1000, 0.001, 'bloom:2')

        # init data in both bloom filters
        yield from bloom1.add('tornado')
        yield from bloom1.add('python')

        yield from bloom2.add('asyncio')
        yield from bloom2.add('python')

        # intersection
        inter_bloom = yield from bloom1.intersection(bloom2)

        in_bloom1 = yield from inter_bloom.contains('python')
        print(in_bloom1)  # True
        in_bloom2 = yield from inter_bloom.contains('asyncio')
        print(in_bloom2)  # False

        # union
        union_bloom = yield from bloom1.intersection(bloom2)

        in_bloom1 = yield from union_bloom.contains('python')
        print(in_bloom1)  # True
        in_bloom2 = yield from union_bloom.contains('asyncio')
        print(in_bloom2)  # True

        redis.close()

    loop.run_until_complete(go())


Requirements
------------

* Python_ 3.3+
* asyncio_ or Python_ 3.4+
* aioredis_
* mmh3_
