# AWS SSO Util

`aws-sso-util` is a utility that extends the AWS CLI's capabilities when working with AWS SSO. It
provides additional functionality for managing credentials, profiles, and sessions beyond what's
available in the standard AWS CLI.

## Installation

Install `aws-sso-util` using pip:

```bash
pip install aws-sso-util
```

## Key Features

### Profile Management

Generate AWS config profiles for all accounts and roles you have access to:

```bash
aws-sso-util configure profile
```

This interactive command will:

1. Prompt for your SSO start URL and region
2. Allow you to select which accounts and roles to configure
3. Generate profiles in your AWS config file

### Login Management

Log in to AWS SSO and get credentials for all profiles at once:

```bash
aws-sso-util login
```

### Profile Naming

Configure custom profile naming schemes:

```bash
aws-sso-util configure profile --profile-name "{account_name}-{role_name}"
```

### Session Management

List active SSO sessions:

```bash
aws-sso-util session list
```

## Integration with AWS CLI

After configuring profiles with `aws-sso-util`, you can use them with the standard AWS CLI:

```bash
aws s3 ls --profile account-name-role-name
```

## Benefits of Using aws-sso-util

1. **Bulk Profile Creation**: Automatically creates profiles for all accounts and roles
2. **Customizable Profile Names**: Offers flexible naming schemes for profiles
3. **Simplified Login**: Single command to authenticate and retrieve credentials for all profiles
4. **Role Chaining Support**: Better handling of role chaining scenarios
5. **Consistent Naming**: Enforces consistent profile naming across teams
6. **Session Management**: Better visibility and control over active sessions
7. **Login Process Automation**: Can be integrated into scripts for automated workflows

## Example Workflow

A typical workflow using `aws-sso-util`:

1. Initial setup:

   ```bash
   aws-sso-util configure profile --sso-start-url https://your-domain.awsapps.com/start --sso-region us-east-1
   ```

2. Daily login:

   ```bash
   aws-sso-util login
   ```

3. Use profiles with standard AWS CLI:

   ```bash
   aws s3 ls --profile dev-admin
   ```

## Advanced Usage

### Configure with JSON File

Create profiles from a JSON configuration file:

```bash
aws-sso-util configure profile --config-file my-config.json
```

Example JSON configuration:

```json
{
  "sso_start_url": "https://your-domain.awsapps.com/start",
  "sso_region": "us-east-1",
  "profile_name": "{account_name}-{role_name}",
  "include_accounts": ["123456789012", "210987654321"],
  "include_roles": ["Admin", "Developer"]
}
```

### Login with Non-interactive Browser

For automation scenarios:

```bash
aws-sso-util login --browser-type none
```

## Comparison with Native AWS CLI SSO

| Feature | Native AWS CLI | aws-sso-util |
|---------|---------------|--------------|
| Profile creation | Manual, one at a time | Bulk creation for all accounts/roles |
| Profile naming | Manual configuration | Templated naming schemes |
| Login process | Per profile or shared | Single login for all profiles |
| Session management | Limited visibility | Enhanced session management |
| Official support | AWS supported | Community maintained |
| Dependencies | AWS CLI only | Requires Python/pip |
| Role chaining | Basic support | Enhanced support |

## Related Resources

- [aws-sso-util GitHub Repository](https://github.com/benkehoe/aws-sso-util)
- [AWS SSO CLI Documentation](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html)
- [[AWS SSO CLI Login]]
