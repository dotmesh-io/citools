#!/bin/sh

(
    flock -n 9 || exit 1

    # Remove all finished test run resources

    for f in `find /dotmesh-test-pools -maxdepth 2 -name finished `
    do
        DIR="`echo $f | sed s_/finished__`"
        echo "Cleaning up $DIR because it's finished..."
        for CMD in `find "$DIR" -name cleanup-actions.\* -print | sort`
        do
            $CMD
        done
        rm -rf "$DIR" || true
    done

    # Remove all stale old test run resources

    for DIR in `find /dotmesh-test-pools -maxdepth 1 -ctime +1`
    do
        echo "Cleaning up $DIR becuase it's stale..."
        for CMD in `find "$DIR" -name cleanup-actions.\* -print | sort`
        do
            $CMD
        done
        rm -rf "$DIR" || true
    done
) 9> /dotmesh-test-pools/cleanup-lock
