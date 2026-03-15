-- Enable uuid extension (required for uuid_generate_v4)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- User
CREATE TABLE "User" (
  "id"         TEXT        NOT NULL DEFAULT concat('user_', uuid_generate_v4()::text),
  "name"       TEXT        NOT NULL,
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3) NOT NULL,
  "avatar"     TEXT        NOT NULL,
  "username"   TEXT        NOT NULL,
  "email"      TEXT        NOT NULL,
  "password"   TEXT        NOT NULL,

  CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "User_username_key" ON "User"("username");
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");

-- Property
CREATE TABLE "Property" (
  "id"              TEXT           NOT NULL DEFAULT concat('prop_', uuid_generate_v4()::text),
  "name"            TEXT           NOT NULL,
  "description"     TEXT           NOT NULL,
  "price_per_night" DOUBLE PRECISION NOT NULL,
  "ownerId"         TEXT           NOT NULL,
  "created_at"      TIMESTAMP(3)   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"      TIMESTAMP(3)   NOT NULL,
  "images"          TEXT[]         NOT NULL,
  "address"         TEXT           NOT NULL,
  "city"            TEXT           NOT NULL,
  "country"         TEXT           NOT NULL,
  "amenities"       TEXT           NOT NULL,
  "capacity"        INTEGER        NOT NULL,
  "longitude"       DOUBLE PRECISION NOT NULL,
  "latitude"        DOUBLE PRECISION NOT NULL,
  "latitude_delta"  DOUBLE PRECISION NOT NULL,
  "longitude_delta" DOUBLE PRECISION NOT NULL,

  CONSTRAINT "Property_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "Property_ownerId_fkey" FOREIGN KEY ("ownerId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX "Property_ownerId_idx" ON "Property"("ownerId");

-- Booking
CREATE TABLE "Booking" (
  "id"                  TEXT           NOT NULL DEFAULT concat('booking_', uuid_generate_v4()::text),
  "created_at"          TIMESTAMP(3)   NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"          TIMESTAMP(3)   NOT NULL,
  "deleted_at"          TIMESTAMP(3),
  "property_id"         TEXT           NOT NULL,
  "user_id"             TEXT           NOT NULL,
  "check_in"            TIMESTAMP(3)   NOT NULL,
  "check_out"           TIMESTAMP(3)   NOT NULL,
  "total_price"         DOUBLE PRECISION NOT NULL,
  "status"              TEXT           NOT NULL DEFAULT 'pending',
  "guest_count"         INTEGER        NOT NULL,
  "special_requests"    TEXT,
  "cancellation_reason" TEXT,
  "payment_intent_id"   TEXT,
  "payment_status"      TEXT           NOT NULL DEFAULT 'pending',

  CONSTRAINT "Booking_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "Booking_property_id_fkey" FOREIGN KEY ("property_id") REFERENCES "Property"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Booking_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX "Booking_property_id_idx" ON "Booking"("property_id");
CREATE INDEX "Booking_user_id_idx" ON "Booking"("user_id");

-- Review
CREATE TABLE "Review" (
  "id"         TEXT         NOT NULL DEFAULT concat('review_', uuid_generate_v4()::text),
  "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at" TIMESTAMP(3) NOT NULL,
  "booking_id" TEXT         NOT NULL,
  "rating"     SMALLINT     NOT NULL,
  "comment"    TEXT,

  CONSTRAINT "Review_pkey" PRIMARY KEY ("id"),
  CONSTRAINT "Review_booking_id_key" UNIQUE ("booking_id"),
  CONSTRAINT "Review_booking_id_fkey" FOREIGN KEY ("booking_id") REFERENCES "Booking"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE INDEX "Review_booking_id_idx" ON "Review"("booking_id");

-- Favorite (composite PK)
CREATE TABLE "Favorite" (
  "user_id"     TEXT         NOT NULL,
  "property_id" TEXT         NOT NULL,
  "created_at"  TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "updated_at"  TIMESTAMP(3) NOT NULL,

  CONSTRAINT "Favorite_pkey" PRIMARY KEY ("user_id", "property_id"),
  CONSTRAINT "Favorite_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT "Favorite_property_id_fkey" FOREIGN KEY ("property_id") REFERENCES "Property"("id") ON DELETE RESTRICT ON UPDATE CASCADE
);
