# Contributing to Torch9 with P9ML

Thanks for your interest in contributing to Torch9 and the P9ML cognitive computing system! There are many ways you can help advance this innovative project.

Please take a moment to review this document to make the contribution process effective for everyone involved.

Following these guidelines helps communicate respect for the developers' time and ensures productive collaboration on this open source cognitive computing project.

## About Torch9 and P9ML

Torch9 extends the classical Torch7 framework with **P9ML (P9 Membrane Layer)** - a revolutionary system implementing membrane computing paradigms within neural substrates. Key areas for contribution include:

- **Core P9ML System**: Membrane computing implementation
- **Cognitive Grammar**: Prime factorization-based tensor analysis
- **Hypergraph Topology**: Cognitive similarity and clustering
- **Evolution Engine**: Adaptive membrane behavior
- **Documentation**: Technical guides and tutorials
- **Performance**: Optimization and scalability improvements


## Using the issue tracker

The issue tracker is the preferred channel for [bug reports](#bugs), [feature requests](#features), and [submitting pull requests](#pull-requests). Please respect the following restrictions:

* Please **do not** use the issue tracker for personal support requests. For P9ML questions, consult the documentation or start a discussion.

* Please **do not** open issues regarding code outside the torch9/P9ML core. For specific torch packages, use their respective issue trackers.

* Please **do not** derail or troll issues. Keep discussions on topic and respect others' opinions.

### P9ML-Specific Issues

When reporting issues related to P9ML functionality, please include:

* **P9ML Version**: System initialization details
* **Membrane Configuration**: Relevant configuration parameters  
* **Cognitive State**: Status information from `P9ML.status()`
* **Tensor Shapes**: Input tensor dimensions and types
* **Evolution State**: Membrane evolution parameters if relevant

<a name="bugs"></a>
## Bug reports

A bug is a _demonstrable problem_ that is caused by the code in the repository.
Good bug reports are extremely helpful - thank you!

Guidelines for bug reports:

1. **Use the GitHub issue search** &mdash; check if the issue has already been
   reported.

2. **Check if the issue has been fixed** &mdash; try to reproduce it using the
   latest `master` or development branch in the repository.

3. **Isolate the problem** &mdash; ideally create test case that is within reason,
   preferably within 100 lines of code.

A good bug report shouldn't leave others needing to chase you up for more
information. Please try to be as detailed as possible in your report. What is
your environment? What steps will reproduce the issue? What OS do you
experience the problem? What would you expect to be the outcome? All these
details will help people to fix any potential bugs.

<a name="features"></a>
## Feature requests

Feature requests are welcome to be filed. Torch is community-developed, 
the maintainers are not exclusive torch developers, so keep that in mind.
The purpose of feature requests is for others who are looking to implement
a feature are aware of the interest in the feature.


<a name="pull-requests"></a>
## Pull requests

Good pull requests - patches, improvements, new features - are a fantastic
help. They should remain focused in scope **and avoid containing unrelated
commits.**

**Please ask first** before embarking on any significant pull request (e.g.
implementing features, refactoring code, porting to a different language),
otherwise you risk spending a lot of time working on something that the
project's developers might not want to merge into the project.

Please adhere to the coding conventions used throughout a project (indentation,
accurate comments, etc.) and any other requirements (such as test coverage).

Adhering to the following this process is the best way to get your work
included in the project:

1. [Fork](https://help.github.com/articles/fork-a-repo) the project, clone your
   fork, and configure the remotes:

   ```bash
   # Clone your fork of the repo into the current directory
   git clone https://github.com/<your-username>/torch7.git
   # Navigate to the newly cloned directory
   cd torch7
   # Assign the original repo to a remote called "upstream"
   git remote add upstream https://github.com/torch/torch7.git
   ```

2. If you cloned a while ago, get the latest changes from upstream:

   ```bash
   git checkout master
   git pull upstream master
   ```

3. Create a new topic branch (off the main project development branch) to
   contain your feature, change, or fix:

   ```bash
   git checkout -b <topic-branch-name>
   ```

4. Commit your changes in logical chunks. Please try to adhere to these [git commit
   message guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
   . Use Git's [interactive rebase](https://help.github.com/articles/about-git-rebase)
   feature to tidy up your commits before making them public. This helps us keep the 
   commit history in logical blocks and clean, as torch grows. 
   For example: 
     - If you are adding a new function or a module, keep the module + tests + doc 
       to a single commit unless logically warranted. 
     - If you are fixing a bug, keep the bugfix to a single commit unless logically warranted.

5. Locally merge (or rebase) the upstream development branch into your topic branch:

   ```bash
   git pull [--rebase] upstream master
   ```

6. Push your topic branch up to your fork:

   ```bash
   git push origin <topic-branch-name>
   ```

7. [Open a Pull Request](https://help.github.com/articles/using-pull-requests/)
    with a clear title and description.

**IMPORTANT**: By submitting a patch, you agree to allow the project owners to
license your work under the terms of the BSD License.
