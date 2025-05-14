# AWS SSO CLI Login

AWS Single Sign-On (SSO) allows you to log in once and access multiple AWS accounts and roles
without having to re-enter credentials. This guide explains how to set up and use AWS SSO with the
AWS CLI.

## Prerequisites

- AWS CLI v2 installed
- Access to AWS SSO (configured by your organization)
- SSO start URL and region information

## Setup

### 1. Install AWS CLI v2

If you haven't already installed AWS CLI v2:

```bash
# macOS (using Homebrew)
brew install awscli

# Verify installation
aws --version
```

### 2. Configure AWS SSO

Configure the AWS CLI to use SSO:

```bash
aws configure sso
```

You'll be prompted for:

- SSO start URL (e.g., `https://your-domain.awsapps.com/start`)
- SSO Region (e.g., `us-east-1`)
- Default output format (json, yaml, text, table)
- Default region

### 3. Create Named Profile

During the configuration, you'll be asked to select an AWS account and role. You can create a named
profile for each account/role combination:

```bash
# Example profile name: dev-admin
```

### 4. Configure SSO Auto-refresh (Optional)

To enable automatic token refresh, add the following to your `~/.aws/config` file:

```ini
[profile your-profile-name]
sso_auto_refresh = true
sso_refresh_window = 43200  # 12 hours in seconds
```

## Usage

### Login Once for All Profiles

To log in once and get a token valid for all accounts and roles:

```bash
aws sso login
```

This opens a browser window for authentication. After successful login, the token is cached and
valid for all profiles that use the same SSO configuration.

### Login to a Specific Profile

```bash
aws sso login --profile profile-name
```

### Verify Login Status

```bash
aws sts get-caller-identity --profile profile-name
```

### Using Multiple Accounts/Roles

Create separate profiles in your `~/.aws/config` file:

```ini
[profile account1-admin]
sso_start_url = https://your-domain.awsapps.com/start
sso_region = us-east-1
sso_account_id = 111122223333
sso_role_name = AdministratorAccess
region = us-east-1
output = json

[profile account2-developer]
sso_start_url = https://your-domain.awsapps.com/start
sso_region = us-east-1
sso_account_id = 444455556666
sso_role_name = DeveloperAccess
region = us-west-2
output = json
```

With this setup, you can log in once with `aws sso login` and then use any profile without
additional authentication:

```bash
aws s3 ls --profile account1-admin
aws ec2 describe-instances --profile account2-developer
```

## Session Duration

By default, SSO sessions last for 8 hours. After expiration, you'll need to log in again
using `aws sso login`.

## Troubleshooting

### Token Expiration

If you see an error like:

```text
The SSO session associated with this profile has expired or is otherwise invalid. To refresh this SSO session run aws sso login with the corresponding profile.
```

Run `aws sso login` again to refresh your token.

### Multiple SSO Configurations

If you have access to multiple SSO providers, ensure you're using the correct SSO start URL for
your organization.

### Credential Process Alternative

For tools that don't support AWS SSO natively, you can use the credential process:

```ini
[profile sso-profile]
credential_process = aws sso get-credentials --profile sso-profile
```

## Best Practices

1. **Use named profiles** for different accounts/roles
2. **Enable auto-refresh** to minimize login frequency
3. **Set default profile** in your shell with `export AWS_PROFILE=your-default-profile`
4. **Use AWS CLI aliases** for common commands across profiles

## Related Resources

- [AWS SSO CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)
- [AWS SSO User Guide](https://docs.aws.amazon.com/singlesignon/latest/userguide/what-is.html)
