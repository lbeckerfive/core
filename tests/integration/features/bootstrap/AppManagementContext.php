<?php
/**
 * @author Victor Dubiniuk <dubiniuk@owncloud.com>
 *
 * @copyright Copyright (c) 2017, ownCloud GmbH.
 * @license AGPL-3.0
 *
 * This code is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License, version 3,
 * as published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License, version 3,
 * along with this program.  If not, see <http://www.gnu.org/licenses/>
 *
 */
 
use Behat\Behat\Context\Context;
use Behat\Behat\Hook\Scope\AfterScenarioScope;
use Behat\Behat\Hook\Scope\BeforeScenarioScope;

require __DIR__ . '/../../../../lib/composer/autoload.php';

/**
 * App Management context.
 */
class AppManagementContext implements  Context {
	
	/** @var string[] */
	private $appInfo;
	
	private $oldAppPath;
	
	/**
	 * @BeforeScenario
	 *
	 * Enable the testing app before the first scenario of the feature and
	 * reset the configs before each scenario
	 * @param BeforeScenarioScope $event
	 */
	public function prepareParameters(BeforeScenarioScope $event){
		$this->oldAppPath = \OC::$server->getConfig()->getSystemValue('app_path', null);
	}
	
	/**
	 * @AfterScenario
	 *
	 * Reset the values after the last scenario of the feature and disable the testing app
	 * @param AfterScenarioScope $event
	 */
	public function undoChangingParameters(AfterScenarioScope $event) {
		if (!is_null($this->oldAppPath)){
			\OC::$server->getConfig()->setSystemValue('app_path', $this->oldAppPath);
		}
	}
	
	/**
	 * @Given apps are in two directories :dir1 and :dir2
	 * @param string $dir1
	 * @param string $dir2
	 */
	public function setAppDirectories($dir1, $dir2){
		$fullpath1 = \OC::$SERVERROOT . '/' . $dir1;
		$fullpath2 = \OC::$SERVERROOT . '/' . $dir2;
		\OC::$server->getConfig()->setSystemValue(
			'app_path',
			sprintf(
				"[['path' => '%s', 'url' => '/%s', 'writable' => true], ['path' => '%s', 'url' => '/%s', 'writable' => true]]",
				$fullpath1,
				$dir1,
				$fullpath2,
				$dir2
			)
		);
	}
	
	/**
	 * @Given App :appId with version :version exists in dir :dir
	 * @param string $appId app id
	 * @param string $version app version
	 * @param string $dir app directory
	 */
	public function appExistsInDir($appId, $version, $dir){
		$ocVersion = \OC::$server->getConfig()->getSystemValue('version', '0.0.0');
		$appInfo = sprintf('<?xml version="1.0"?>
			<info>
				<id>%s</id>
				<name>%s</name>
				<description>description</description>
				<licence>AGPL</licence>
				<author>Author</author>
				<version>%s</version>
				<category>collaboration</category>
				<website>https://github.com/owncloud/</website>
				<bugs>https://github.com/owncloud/</bugs>
				<repository type="git">https://github.com/owncloud/</repository>
				<screenshot>https://raw.githubusercontent.com/owncloud/screenshots/</screenshot>
				<dependencies>
					<owncloud min-version="%s" max-version="%s" />
				</dependencies>
			</info>',
			$appId,
			$appId,
			$version,
			$ocVersion,
			$ocVersion
		);
		$fullpath = \OC::$SERVERROOT . '/' . $dir;
		if (!file_exists($fullpath . '/appinfo')){
			mkdir($fullpath . '/appinfo', true);
		}
		file_put_contents($fullpath . '/appinfo/info.xml', $appInfo);
	}
	
	/**
	 * @When App :appId is loaded
	 * @param string $appId app id
	 */
	public function loadApp($appId){
		$appManager = \OC::$server->getAppManager();
		$this->appInfo = $appManager->getAppInfo($appId);
	}
	
	/**
	 * @Then :appId version should be :version
	 * @param string $appId
	 * @param string $version
	 */
	 public function appVersionIs($appId, $version){
		PHPUnit_Framework_Assert::assertEquals($appId, $this->appInfo['id']);
		PHPUnit_Framework_Assert::assertEquals($version, $this->appInfo['version']);
	}
}
