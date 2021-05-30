import 'package:flutter/material.dart';
import 'package:github_graphql_client/github_gql/github_queries.data.gql.dart';
import 'package:github_graphql_client/github_gql/github_queries.req.gql.dart';
import 'package:github_graphql_client/secrets.dart';
import 'package:github_graphql_client/views/github_login_widget.dart';
import 'package:github_graphql_client/views/github_summary_list.dart';
import 'package:gql_exec/gql_exec.dart';
import 'package:gql_link/gql_link.dart';
import 'package:window_to_front/window_to_front.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GithubLoginWidget(
      builder: (context, client) {
        WindowToFront.activate();
        return Scaffold(
          appBar: AppBar(
            title: Text('GitHub GraphQL client'),
          ),
          body: GitHubSummary(client: client),
        );
      },
      githubClientId: githubClientId,
      githubClientSecret: githubClientSecret,
      githubScopes: githubScopes,
    );
  }
}

Future<GViewerDetailData_viewer> viewerDetail(Link link) async {
  final req = GViewerDetail((b) => b);
  final result = await link
      .request(Request(
        operation: req.operation,
        variables: req.vars.toJson(),
      ))
      .first;
  final errors = result.errors;
  if (errors != null && errors.isNotEmpty) {
    throw QueryException(errors);
  }
  return GViewerDetailData.fromJson(result.data!)!.viewer;
}

class QueryException implements Exception {
  QueryException(this.errors);
  List<GraphQLError> errors;
  @override
  String toString() {
    return 'Query Exception: ${errors.map((err) => '$err').join(',')}';
  }
}
