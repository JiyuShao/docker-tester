package internal

import (
	tester_utils "github.com/codecrafters-io/tester-utils"
)

func testBasicExec(stageHarness *tester_utils.StageHarness) error {
	initRandom()

	logger := stageHarness.Logger
	executable := stageHarness.Executable

	randomStr := randomString(99999)

	logger.Debugf("Executing: ./your_docker.sh run <some_image> /usr/local/bin/docker-explorer echo %s", randomStr)
	result, err := executable.Run(
		"run", DOCKER_IMAGE_STAGE_1,
		"/usr/local/bin/docker-explorer", "echo", randomStr,
	)
	if err != nil {
		return err
	}

	logger.Debugf("Checking if the command output was echo-ed..")
	return assertStdoutContains(result, randomStr)
}
