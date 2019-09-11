#!/bin/bash

set -e
set -x

if [[ $DEVSTACK == 'lms' ]]; then
    make dev.provision
    make dev.up
    sleep 60  # LMS needs like 60 seconds to come up
    make healthchecks
    docker run -t --network=devstack_default -v ${DEVSTACK_WORKSPACE}/edx-e2e-tests:/edx-e2e-tests -v ${DEVSTACK_WORKSPACE}/edx-platform:/edx-e2e-tests/lib/edx-platform --env-file ${DEVSTACK_WORKSPACE}/edx-e2e-tests/devstack_env edxops/e2e env TERM=$(TERM) bash -c 'paver e2e_test --exclude="whitelabel\|enterprise"'
    #make healthchecks
    #make lms-static
    
    #pwd
    #paver test_bokchoy
    make validate-lms-volume
    # Disable e2e-tests until either:
    # * tests are less flaky
    # * We have a way to test the infrastructure for testing but ignore the test results.
    # See PLAT-1712
    # make e2e-tests
    #make up-marketing-detached
fi

#if [[ $DEVSTACK == 'analytics_pipeline' ]]; then
   # make dev.provision.analytics_pipeline
    #make dev.up.analytics_pipeline
    #sleep 30 # hadoop services need some time to be fully functional and out of safemode
   # make analytics-pipeline-devstack-test
#fi
