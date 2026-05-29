# Gracenote Showtime Ingestion

This Terraform stack creates the infrastructure for server-side Gracenote/TMS showtime ingestion. The Gracenote API key must never be exposed to client-side Next.js code, committed to Terraform variables, or stored in Terraform state.

## API Key Setup

Terraform creates the Secrets Manager secret container from `var.gracenote_secret_name`, but it does not create a secret version or store the API key value.

Populate the secret manually after apply:

```sh
aws secretsmanager put-secret-value \
  --secret-id "<secret-name>" \
  --secret-string "<gracenote-api-key>"
```

The default secret name is `/cmc/production/gracenote/api-key`.

## Defaults

The scheduled refresh uses these defaults unless variables are overridden:

- ZIP: `60422`
- Radius: `30`
- Number of days: `14`
- Units: `mi`
- Timezone: `America/Chicago`
- Gracenote base URL: `http://data.tmsapi.com/v1.1`

## Scheduled Refresh

`gracenote_refresh_schedule_enabled` controls whether the EventBridge rule is enabled. Set it to `false` to keep the rule deployed but disabled.

`gracenote_refresh_schedule_expression` defaults to `cron(0 11 * * ? *)`, which is roughly morning in Chicago depending on daylight savings.

## Manual Coordinator Test

Invoke the coordinator Lambda with an explicit payload:

```sh
aws lambda invoke \
  --function-name cmc-gracenote-showtime-coordinator-lambda \
  --payload '{"source":"manual","provider":"gracenote","zip":"60422","radius":30,"numDays":14,"units":"mi"}' \
  response.json
```

## Admin API Test

Terraform wires `POST /admin/showtimes/gracenote/refresh` to the coordinator Lambda. It uses the existing API Gateway REST API, Cognito authorizer, and API key requirement.

Example request shape:

```sh
curl -X POST "https://<api-id>.execute-api.<region>.amazonaws.com/development/admin/showtimes/gracenote/refresh" \
  -H "Authorization: Bearer <cognito-id-token>" \
  -H "x-api-key: <api-gateway-api-key>" \
  -H "Content-Type: application/json" \
  -d '{"zip":"60422","radius":30,"numDays":14,"units":"mi"}'
```

## Data Storage

The worker stores normalized Gracenote cache records in the existing Movie Club DynamoDB app table. Terraform enables TTL on the table using the `expiresAt` attribute so cached showtimes can expire naturally.
