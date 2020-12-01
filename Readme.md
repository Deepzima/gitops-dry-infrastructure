# DEVOPS HANDMADE CHALLENGE 

## Ground Rules
We prefer well-thought-out solutions over the quick-and-dirty kind. So take your time, if you need it. A rushed job is usually matched by a swift rejection.

Submission is done via a git format-patch. 

## Context

We have outsourced this application development to an external company. The application contains the following features:

Member sign up/sign in
Download documents
The application was developed using Rust.

The application requires a database for storing data. Use PostgreSQL, and support HA (high availability).

## Problem

As an architect, you decide to deploy the application using Kubernetes and use PostgreSQL as the database.

## Instructions

Write scripts and yaml files, in order to run this application on a Kubernetes cluster, i.e. Helm charts or Kubernetes manifests.
Write scripts and yaml files, in order to setup PostgreSQL inside a Kubernetes cluster, optionally in High Availability mode, i.e. Patroni/Spilo with master/slave.
You may need to modify the application source code or configuration in order to make the application running on Kubernetes cluster, e.g. make use ENV variables in 12Factor style, create Dockerfile.
You have to write documentation and/or instructions about what you have done. This documents must detail steps for other DevOps to understand how to deploy this application and maintain it.