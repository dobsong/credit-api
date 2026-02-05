# credit-api
Rails API for CREDIT

## Resources

This API provides two main resources for managing user project plans and reading lists.

### Project Plans

**Model:** `ProjectPlan`  
**Controller:** `ProjectPlanController`  
**Route:** `/project_plan` (singular resource)

Project Plans are user-specific resources. Each user has exactly one project plan, identified by their Keycloak username.

**Fields:**
- `user` - Username from Keycloak (unique)
- `title` - Project title
- `previous_engagement` - Previous engagement information
- `has_started` - Boolean indicating if the project has started
- `vision` - Project vision
- `laymans_summary` - Lay person's summary
- `stakeholder_analysis` - Stakeholder analysis
- `approach` - Project approach
- `data` - Data considerations
- `ethics` - Ethics considerations
- `platform` - Platform information
- `support_materials` - Supporting materials
- `costings` - Cost information

**Endpoints:**
- `GET /project_plan` - Retrieve the current user's project plan (creates if doesn't exist)
- `POST /project_plan` - Create a project plan
- `PATCH/PUT /project_plan` - Update the current user's project plan
- `DELETE /project_plan` - Delete the current user's project plan

### Reading Lists

**Models:** `ReadingList`, `BibliographyReference`  
**Controller:** `ReadingListsController`  
**Routes:** `/reading_lists`

Reading Lists allow users to maintain a collection of bibliography references. The system uses two models to minimise storage redundancy:
- `BibliographyReference` - Stores unique bibliography entries (shared across users)
- `ReadingList` - Joins users to bibliography references (user-specific)

**BibliographyReference Fields:**
- `citation` - Unique citation string
- `title` - Reference title
- `authors` - Authors
- `year` - Publication year
- `url` - Reference URL

**ReadingList Fields:**
- `user` - Username from Keycloak
- `bibliography_id` - Foreign key to BibliographyReference

**Endpoints:**
- `GET /reading_lists` - List all reading list entries for the current user
- `POST /reading_lists` - Add a bibliography reference to the user's reading list (creates bibliography entry if needed)
- `DELETE /reading_lists/:id` - Remove an entry from the user's reading list

**Note:** The index endpoint merges bibliography reference data with reading list metadata (id, timestamps) to provide a flattened response for client convenience.

## Authentication & Authorization

### Keycloak Integration

This API uses Keycloak for authentication via JWT bearer tokens. All endpoints require authentication.

**Components:**
- `KeycloakAuthenticatable` (concern) - Included in `ApplicationController` to protect all endpoints
- `KeycloakService` - Handles fetching and caching Keycloak's public key for JWT verification

**How it works:**
1. Client sends requests with `Authorization: Bearer <token>` header
2. `KeycloakAuthenticatable` extracts and validates the JWT token
3. Token is decoded using Keycloak's RS256 public key (fetched from Keycloak's JWKS endpoint)
4. Token issuer is verified against the configured Keycloak realm
5. User information (username, roles) is extracted from the token claims
6. Username (`preferred_username` claim) is used to scope resources per user

**Configuration:**
Keycloak settings are configured in `config/initializers/keycloak.rb`:
- `auth_server_url` - Keycloak server URL
- `realm` - Keycloak realm name

**Available Helper Methods:**
- `current_user` - Returns the decoded token payload
- `current_user_roles` - Returns the user's realm roles
- `has_role?(role)` - Checks if user has a specific role

**Security:**
- All endpoints automatically require authentication
- Resource access is scoped to the authenticated user's `preferred_username`
- Reading list deletions verify ownership before allowing deletion
- JWT signature verification ensures token integrity

## Environment Variables

### Database Configuration

The following environment variables configure the PostgreSQL database connection:

- `CREDIT_API_DATABASE_HOST` - Database host (default: `localhost`)
- `CREDIT_API_DATABASE_PORT` - Database port (default: `5432`)
- `CREDIT_API_DATABASE_NAME` - Database name (default: `credit_api_production`)
- `CREDIT_API_DATABASE_USERNAME` - Database username (default: `credit_api`)
- `CREDIT_API_DATABASE_PASSWORD` - Database password (required in production)

**Note:** When running in Docker, use `172.17.0.1` (Docker bridge gateway) to connect to PostgreSQL on the host, or place containers on the same Docker network.

### CORS
Allowed origins can be set via the `CORS_ORIGINS` environment variable, which should be a comma-separated list of allowed origins. If not set, it defaults to allowing localhost on port 5173.

### Keycloak Configuration

The following environment variables configure Keycloak authentication:

- `KEYCLOAK_URL` - Keycloak server URL (default: `http://localhost:8080`)
- `KEYCLOAK_REALM` - Keycloak realm name (default: `credit`)
- `KEYCLOAK_ISSUER` - (Optional) Explicit issuer for JWT validation. If not set, defaults to `{KEYCLOAK_URL}/realms/{KEYCLOAK_REALM}`

**Example for Docker:**
```bash
sudo docker run -p 3000:80
	-e RAILS_MASTER_KEY=<key from config/master.key>
	-e CREDIT_API_DATABASE_NAME=credit_api_development
	-e CREDIT_API_DATABASE_USERNAME=credit_api
	-e  CREDIT_API_DATABASE_HOST=172.17.0.1
	-e CREDIT_API_DATABASE_PORT=5432
	-e CREDIT_API_DATABASE_PASSWORD=test
	-e KEYCLOAK_REALM=credit
	-e KEYCLOAK_URL=http://172.17.0.1:8080
	-e KEYCLOAK_ISSUER=http://localhost:8080/realms/credit
	 --name credit-api credit-api
```

**Note:** When running Keycloak in a separate Docker container, use the container name as hostname if on the same Docker network (note that the existing Dockerfile is not setup to do this), or `172.17.0.1` if exposed on the host.