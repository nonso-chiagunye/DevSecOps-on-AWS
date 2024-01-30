<h1 align="center">DevSecOps on AWS</h1>

<p align="center">Demonstrated with <a href="https://nodejs.org">NodeJS</a> App - <a href="https://ike-fitness.onrender.com">Ike Fitness</a></p>

---

<div align="center" style="display: flex; flex-direction: column; justify-content: center; align-items: center;">
  <img src="ike-aws-architecture.gif" alt="Ike Fitness" width="800"/>
</div>

---

# DevSecOps Pipeline Steps

- Push Code to AWS CodeCommit repository
- Code is checked out by AWS CodePipeline and sent to AWS CodeBuild
- AWS CodeBuild Downloads necessary secret variables from AWS Secrets Manager
- AWS CodeBuild installs the necessary packages and dependencies for the entire build project
- Code Quality Test is performed by [SonarCloud](https://www.sonarsource.com/products/sonarcloud/) and result saved in SonarCloud project
- The result is curled from SonarCloud project and check the _Quality Gates_. If Quality gate failed, pipeline exit
- Open Source or 3rd party libraries are tested for security vulnerabilities (SCA) with [Snyk](https://snyk.io/)
- If a vulnerability with CVSS Score >= 7 is discovered, pipeline exit
- Code is tested for vulnerability (SAST) with Snyk.
- If a vulnerability at level 'error' is discovered, pipeline exit
-
