---
eleventyNavigation:
  key: RepositoryPermissions
  title: Repository Permissions
  parent: Collaborating
  order: 50
---

When you invite collaborators to join your repository (see [Invite Collaborators](/collaborating/invite-collaborators)) or when you create teams for your organization (see [Create and Manage an Organization](/collaborating/create-organization)), you have to decide what each collaborator/team is allowed to do.

Since Gitea v1.16, you can assign teams different levels of permission for each unit (e.g. issues, PR's, wiki).

## Collaborators

There are four permission levels: Read, Write, Administrator and Owner.  
The owner is the person who created the repository.

The table below gives an overview of what collaborators are allowed to do when granted each of these permission levels:

<table class="table">
 <thead>
  <tr>
   <th> Task </th>
   <th> Read </th>
   <th> Write</th>
   <th> Admin </th>
   <th> Owner </th>
 </thead>
 <tbody>
  <tr>
   <td> View, clone and pull repository </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Contribute pull requests </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Push to/update contributed pull requests </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Push directly to repository </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Merge pull requests </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Moderate/delete issues and comments </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Force-push/rewrite history (if enabled) </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Add/remove collaborators to repository </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Configure branch settings (protect/unprotect, enable force-push) </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  <tr>
   <td> Configure repository settings (enable wiki, issues, PRs, update profile) </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  <tr>
   <td> Configure repository settings in the danger zone (transfer ownership, delete wiki data / repository, archive repository) </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: red">{% fas_icon "times" %}</span> </td>
   <td> <span style="color: green">{% fas_icon "check" %}</span> </td>
  </tr>
  </tr>
 </tbody>
</table>


## Teams

The permissions for teams are quite configurable. You can specify which repositories a team has access to; therefore, you can specify for each unit (Code Access, Issues, Releases) a different permission level.

Each unit is configured to have one of these 3 permission levels:

- No Access: Members cannot view or take any other action on this unit.
- Read: Members can view the unit, and do standard actions for that unit (See the Read column under [Collaborators](#collaborators)).
- Write: Members can view the unit, and execute write actions that unit (See the Write column under [Collaborators](#collaborators)).

When a team is configured to have administrator access, when this is specified, you cannot change units. The team will have admin permissions (See the Admin column under [Collaborators](#collaborators)).

Currently, there are six units that can be configured:

- Code: access source code, files, commits, and branches.
- Issues: organize bug reports, tasks, and milestones.
- Pull Requests: access pull requests, and code reviews.
- Releases: track the project versions and downloads.
- Wiki: access and write documentation.
- Projects: access and manage issues and pull requests in project boards.

There are also two units which can be toggled:

- External Wiki: access to external wiki.
- External Issues: access to the external issue tracker.

A team can be given the permission to create new repositories. When a member of such team creates a new repository, he/she will get administrator access to the repository.
