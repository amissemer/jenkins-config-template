Template for a versionable Jenkins instance
===========================================

Prepare the Jenkins config repository
------------
* Create a git repository with the content of this archive (do not forget the `.gitignore`)
* Create a branch to track your Jenkins instance configuration
* Edit the docker-compose.yml file:
** JENKINS_CONFIG_REPOSITORY: the URL of the remote in the JENKINS_CONFIG_REPOSITORY environment variable
** JENKINS_CONFIG_BRANCH: the name of the branch that will track jenkins configuration pushed from this Jenkins instance (make sure this branch already exists in the repository)
* Optional: An initial list of plugins can be installed by listing them under jenkins-config/plugins.txt
* Optional: Jenkins SSH key can be provided under jenkins-config/.ssh/id_rsa and will be configured in Jenkins as the default git credential. If not provided, a key will be generated (in that case, use ./passwd.sh to retrieve the public certificate and add it to your repository as a R/W key).
* Push the git branch to the remote

### Tip
If you want to store the configuration in a different subdirectory than jenkins-config, simply set JENKINS_CONFIG_PATH to the directory of your choice

First startup
-------------
* Start jenkins for the first time using the provided docker-compose.yml file
* Go through Jenkins install wizard (create the first admin user)
** You may install additional plugins, if you do, restart Jenkins after the Wizard is complete, see Tip below.
* Run the commit-jenkins-config job and make sure it builds successfully.

You should see a commit in the remote repository with the base configuration for your project.

Commit the configuration
------------------------

* Add plugins and update the configuration as usual.
* When you're ready to commit the configuration, run the commit-jenkins-config job (provide a comment like you would for a commit with git
* The list of plugins and their version is part of the configuration
* Warning: when you commit the configuration, Jenkins does not try to merge the changes that could have been done manually or from a different instance in the JENKINS_CONFIG_BRANCH, it simply creates a new commit by overwriting all configuration files.

### Tip
After installing a plugin from the UpdateCenter, always restart before committing Jenkins configuration with the git repository (this will stabilize the versions of the plugins): docker-compose restart

Upgrading the configuration
---------------------------

This is the reverse operation from the commit. It uses the git repository to overwrite all Jenkins configuration files and installed plugins

* In the same way you installed jenkins (through command line in this folder) type:

	```bash
	docker-compose build
	docker-compose down
	docker-compose run jenkins upgrade
	docker-compose up -d
	```

Here is a typical workflow taking advantage of the commit and upgrade features to synchronize a Staging and a Production Jenkins instance:

1. Commit the Production Jenkins configuration in the `master` branch
2. Create a `develop` branch from the `master` branch
3. (Re)initialize the Staging Jenkins from the `develop` branch (`files="-p jenkins-staging -f docker-compose.yml -f docker-compose.staging.yml"; docker-compose $files build && docker-compose $files down -v && docker-compose $files up -d`)
4. Experiment with configuration changes and plugins in Staging
5. Commit the Staging configuration from Jenkins
6. Optional: review the list of plugins in the git repo, commit in the `develop` branch
7. Optional: test the upgrade against the Staging Jenkins (`files="-p jenkins-staging -f docker-compose.yml -f docker-compose.staging.yml"; docker-compose $files build && docker-compose $files down && docker-compose $files run jenkins upgrade && docker-compose $files up -d`)
8. Commit the Production Jenkins configuration in the `master` branch one more time (in case some changes have been made since step 1)
9. Merge `develop` into `master`
10. Upgrade Production Jenkins from the `master` branch

