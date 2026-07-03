# Home Calendar API

**Version:** 1.0.0

API for managing calendar events, including recurring series.

**Base URL:** `{protocol}://{host}:{port}` (default: `http://localhost:3000`)


## Endpoints

### `GET /api/v1/events` - List events in a date range

**Query Parameters:**

| Name | Required | Type | Description |
|------|----------|------|-------------|
| `start` | yes | string (date-time) | Start of the date range (inclusive) |
| `end` | yes | string (date-time) | End of the date range (inclusive) |

**Responses:**

- `200` - Array of `Event` objects
- `400` - Missing or invalid parameters (plain text)

---

### `POST /api/v1/events` - Create a new event (or series)

**Request Body:** `EventInput` (JSON)

**Responses:**

- `201` - Array of created `Event` objects
- `400` - Array of validation error strings

---

### `GET /api/v1/events/{id}` - Retrieve a single event

**Path Parameters:**

| Name | Required | Type | Description |
|------|----------|------|-------------|
| `id` | yes | integer | Event ID |

**Responses:**

- `200` - `Event` object
- `404` - Empty object

---

### `PATCH /api/v1/events/{id}` - Update an event (or series)

**Path Parameters:**

| Name | Required | Type | Description |
|------|----------|------|-------------|
| `id` | yes | integer | Event ID |

**Request Body:** `EventInput` (JSON)

**Responses:**

- `200` - Array of updated `Event` objects
- `400` - Array of validation error strings
- `404` - Empty object

---

### `DELETE /api/v1/events/{id}` - Delete an event (or series)

**Path Parameters:**

| Name | Required | Type | Description |
|------|----------|------|-------------|
| `id` | yes | integer | Event ID |

**Query Parameters:**

| Name | Required | Type | Description |
|------|----------|------|-------------|
| `apply_to_series` | no | boolean | If true, delete the entire series; otherwise delete only this occurrence |

**Responses:**

- `204` - Event(s) deleted
- `404` - Empty object

---

## Schemas

### `Event`

| Property | Type | Required | Notes |
|----------|------|----------|-------|
| `id` | integer | yes | |
| `title` | string | no | |
| `start` | string (date-time) | yes | |
| `end` | string (date-time) | yes | |
| `color` | string (enum) | no | `""`, `black`, `green`, `red`, `midnightblue`, `indigo`, `darkorange`, `sienna`, `teal` |
| `created_at` | string (date-time) | no | |
| `updated_at` | string (date-time) | no | |
| `recurring_uuid` | string | no | nullable |

---

### `EventInput`

Wraps event fields under an `event` key.

| Property | Type | Required | Notes |
|----------|------|----------|-------|
| `event.title` | string | no | |
| `event.start` | string (date-time) | yes | |
| `event.end` | string (date-time) | yes | |
| `event.color` | string (enum) | no | `""`, `black`, `green`, `red`, `midnightblue`, `indigo`, `darkorange`, `sienna`, `teal` |
| `event.recurring_times` | integer | no | |
| `event.apply_to_series` | string (enum) | no | `"0"`, `"1"`, or null |
| `event.recurring_schedule` | string (enum) | no | `daily`, `weekly`, `monthly`, `every 2 weeks`, `every other day`, or null |
