# Section 4: Data Structure and Storage

This section outlines the schema for Cloud SQL (PostgreSQL) and the management of media files in Cloud Storage.

## 1. Cloud SQL Schema

### `users` Table
| Column | Data Type | Constraints | Notes |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY | User ID. |
| `language_code` | STRING (e.g., 'ja', 'en') | NOT NULL | **App/Generation Language (R4.1)**. |
| `writing_tone` | STRING | NOT NULL | User's chosen writing style (e.g., 'POETIC'). |
| `art_style` | STRING | NOT NULL | User's chosen art style (e.g., 'WATERCOLOR'). |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT now() | Row creation timestamp. |
| `updated_at` | TIMESTAMP | NOT NULL | Managed by triggers/app. |

### `diaries` Table
| Column | Data Type | Constraints | Notes |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY | Diary Entry ID. |
| `user_id` | UUID | FOREIGN KEY | Reference to `users`. |
| `final_text` | TEXT | NOT NULL | **User-corrected final text (R3.2)**. |
| `image_url` | STRING | NOT NULL | Cloud Storage path for the final image. |
| `latitude` | NUMERIC | | Location Latitude (R1.3). |
| `longitude` | NUMERIC | | Location Longitude (R1.3). |
| `place_name` | STRING | | Human-readable place name. |
| `timezone` | STRING | | Olson TZ for calendar display consistency. |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT now() | For calendar sorting. |
| `updated_at` | TIMESTAMP | NOT NULL | For edits. |

**Indexes:**
* `diaries(user_id)` and `diaries(user_id, created_at)` to speed calendar views.

### `user_style_data` Table (Learning Data)
This table is crucial for the AI's personalization mechanism.
| Column | Data Type | Constraints | Notes |
| :--- | :--- | :--- | :--- |
| `id` | UUID | PRIMARY KEY | |
| `user_id` | UUID | FOREIGN KEY | |
| `language_code` | STRING | NOT NULL | **Language of the stored style fragment (R4.4)**. |
| `style_fragment`| TEXT | NOT NULL | User's style sample (full corrected text or extracted summary). |
| `timestamp` | TIMESTAMP | NOT NULL | For freshness management. |
| `created_at` | TIMESTAMP | NOT NULL, DEFAULT now() | Creation time. |
| `updated_at` | TIMESTAMP | NOT NULL | For edits. |

**Constraints/Indexes:**
* Unique on `(user_id, language_code, timestamp)` to prevent duplicate inserts.
* Index on `(user_id, language_code)` for fast retrieval and language isolation.

## 2. Cloud Storage

Cloud Storage will be configured with private buckets. Access to files will be controlled by the Go backend, generating signed URLs for secure, temporary frontend access when displaying images.

| File Type | Storage Path Pattern | Access Control |
| :--- | :--- | :--- |
| **User Uploads** | `gs://[BUCKET]/users/{user_id}/uploads/{upload_id}.[ext]` | Private |
| **Generated Images** | `gs://[BUCKET]/diaries/{diary_id}/final.webp` | Private |

**Access Policy:** Signed URLs are short-lived (e.g., 10-15 minutes) and scoped per object; no public ACLs.
