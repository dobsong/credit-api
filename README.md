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
