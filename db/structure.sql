--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: accounts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE accounts (
    id integer NOT NULL,
    state character varying(255),
    parent_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;


--
-- Name: admin_tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE admin_tags (
    id integer NOT NULL,
    taggable_type character varying(255) NOT NULL,
    defective character varying(255) NOT NULL,
    corrected character varying(255)
);


--
-- Name: admin_tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE admin_tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: admin_tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE admin_tags_id_seq OWNED BY admin_tags.id;


--
-- Name: assets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE assets (
    id integer NOT NULL,
    name character varying(255),
    site_id integer,
    asset_file_name character varying(255),
    asset_content_type character varying(255),
    asset_file_size integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    type character varying(255)
);


--
-- Name: assets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE assets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: assets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE assets_id_seq OWNED BY assets.id;


--
-- Name: biometric_people_values; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE biometric_people_values (
    id integer NOT NULL,
    person_id integer NOT NULL,
    domain_id integer NOT NULL,
    value_id integer,
    value character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: biometric_people_values_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE biometric_people_values_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: biometric_people_values_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE biometric_people_values_id_seq OWNED BY biometric_people_values.id;


--
-- Name: bookmarks; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE bookmarks (
    id integer NOT NULL,
    wave_id integer,
    user_id integer,
    created_at timestamp without time zone,
    read_at timestamp without time zone
);


--
-- Name: bookmarks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE bookmarks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: bookmarks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE bookmarks_id_seq OWNED BY bookmarks.id;


--
-- Name: delayed_jobs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE delayed_jobs (
    id integer NOT NULL,
    priority integer DEFAULT 0,
    attempts integer DEFAULT 0,
    handler text,
    last_error text,
    run_at timestamp without time zone,
    locked_at timestamp without time zone,
    failed_at timestamp without time zone,
    locked_by character varying(255),
    queue character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE delayed_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: delayed_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE delayed_jobs_id_seq OWNED BY delayed_jobs.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE friendships (
    id integer NOT NULL,
    type character varying(255),
    user_id integer,
    friend_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    state character varying(255)
);


--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendships_id_seq OWNED BY friendships.id;


--
-- Name: invitation_confirmations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitation_confirmations (
    id integer NOT NULL,
    invitation_id integer,
    friendship_id integer,
    invitee_id integer
);


--
-- Name: invitation_confirmations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitation_confirmations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitation_confirmations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitation_confirmations_id_seq OWNED BY invitation_confirmations.id;


--
-- Name: invitations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE invitations (
    id integer NOT NULL,
    type character varying(255),
    site_id integer,
    user_id integer,
    email character varying(255),
    code character varying(255),
    state character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    expired_at timestamp without time zone
);


--
-- Name: invitations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE invitations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invitations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE invitations_id_seq OWNED BY invitations.id;


--
-- Name: launch_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE launch_users (
    id integer NOT NULL,
    email character varying(255),
    created_at timestamp without time zone,
    site character varying(255)
);


--
-- Name: launch_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE launch_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: launch_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE launch_users_id_seq OWNED BY launch_users.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying(255),
    address character varying(255),
    street character varying(255),
    locality character varying(255),
    city character varying(255),
    state character varying(255),
    country character varying(255),
    post_code character varying(255),
    lat numeric(10,7),
    lng numeric(10,7),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE notifications (
    id integer NOT NULL,
    user_id integer,
    posting_id integer,
    created_at timestamp without time zone,
    read_at timestamp without time zone
);


--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;


--
-- Name: personages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personages (
    id integer NOT NULL,
    user_id integer,
    persona_id integer,
    profile_id integer,
    state character varying(255),
    "default" boolean DEFAULT false,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: personages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personages_id_seq OWNED BY personages.id;


--
-- Name: personas; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE personas (
    id integer NOT NULL,
    dob date,
    age character varying(255),
    location character varying(255),
    description text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    handle character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    avatar_id integer,
    type character varying(255),
    score integer DEFAULT 0,
    address character varying(255),
    subpremise character varying(255),
    street_number character varying(255),
    street character varying(255),
    neighborhood character varying(255),
    sublocality character varying(255),
    locality character varying(255),
    city character varying(255),
    abbreviated_state character varying(255),
    state character varying(255),
    country character varying(255),
    post_code character varying(255),
    lat numeric(10,7),
    lng numeric(10,7),
    emailable boolean DEFAULT false,
    featured boolean DEFAULT false
);


--
-- Name: personas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE personas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: personas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE personas_id_seq OWNED BY personas.id;


--
-- Name: postings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE postings (
    id integer NOT NULL,
    type character varying(255),
    slug character varying(255),
    user_id integer,
    parent_id integer,
    resource_id integer,
    resource_type character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    subject text,
    body text,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size integer,
    sticky_until timestamp without time zone,
    width integer,
    height integer,
    horizontal boolean,
    state character varying(255),
    hash_key character varying(8),
    comments_count integer DEFAULT 0,
    postings_count integer DEFAULT 0,
    commented_at timestamp without time zone,
    primed_at timestamp without time zone,
    wave_id integer
);


--
-- Name: postings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE postings_id_seq OWNED BY postings.id;


--
-- Name: publications; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE publications (
    id integer NOT NULL,
    wave_id integer NOT NULL,
    posting_id integer NOT NULL,
    created_at timestamp without time zone,
    parent_id integer
);


--
-- Name: publications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE publications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: publications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE publications_id_seq OWNED BY publications.id;


--
-- Name: resource_embeds; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource_embeds (
    id integer NOT NULL,
    resource_link_id integer,
    type character varying(255),
    "primary" integer DEFAULT 0,
    body text,
    width integer,
    height integer,
    duration double precision
);


--
-- Name: resource_embeds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_embeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_embeds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_embeds_id_seq OWNED BY resource_embeds.id;


--
-- Name: resource_events; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource_events (
    id integer NOT NULL,
    location_id integer,
    start_date timestamp without time zone,
    end_date timestamp without time zone,
    body text,
    url character varying(255),
    private boolean,
    rsvp boolean
);


--
-- Name: resource_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_events_id_seq OWNED BY resource_events.id;


--
-- Name: resource_links; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE resource_links (
    id integer NOT NULL,
    posting_id integer,
    original_url text,
    url text,
    type character varying(255),
    cache_age integer,
    safe boolean,
    safe_type character varying(255),
    safe_message text,
    provider_name character varying(255),
    provider_url character varying(255),
    provider_display character varying(255),
    favicon_url text,
    title text,
    description text,
    author_name text,
    author_url text,
    content text,
    location_id integer
);


--
-- Name: resource_links_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE resource_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: resource_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE resource_links_id_seq OWNED BY resource_links.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: signal_categories; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signal_categories (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    display_name character varying(255),
    site_id integer,
    ordinal integer
);


--
-- Name: signal_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE signal_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signal_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE signal_categories_id_seq OWNED BY signal_categories.id;


--
-- Name: signal_categories_signals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signal_categories_signals (
    id integer NOT NULL,
    signal_id integer,
    category_id integer,
    ordinal integer,
    pane integer
);


--
-- Name: signal_categories_signals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE signal_categories_signals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signal_categories_signals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE signal_categories_signals_id_seq OWNED BY signal_categories_signals.id;


--
-- Name: signals; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE signals (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    display_name character varying(255),
    type character varying(255)
);


--
-- Name: signals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE signals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: signals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE signals_id_seq OWNED BY signals.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    display_name character varying(255) NOT NULL,
    launch boolean DEFAULT false,
    invite_only boolean DEFAULT false,
    analytics_domain_name character varying(255),
    analytics_account_number character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    css text,
    mailer character varying(255),
    user_id integer,
    email_domain_regex character varying(255),
    email_domain_display_name character varying(255)
);


--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sites_id_seq OWNED BY sites.id;


--
-- Name: sites_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites_users (
    site_id integer,
    user_id integer
);


--
-- Name: sites_waves; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sites_waves (
    site_id integer,
    wave_id integer
);


--
-- Name: stylesheets; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE stylesheets (
    id integer NOT NULL,
    site_id integer NOT NULL,
    controller_name character varying(255),
    css text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: stylesheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE stylesheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: stylesheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE stylesheets_id_seq OWNED BY stylesheets.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    resource_id integer NOT NULL,
    resource_type character varying(255),
    type character varying(255) NOT NULL,
    state character varying(255),
    notified_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: taggings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE taggings (
    id integer NOT NULL,
    tag_id integer,
    taggable_id integer,
    taggable_type character varying(255),
    tagger_id integer,
    tagger_type character varying(255),
    context character varying(255),
    created_at timestamp without time zone
);


--
-- Name: taggings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE taggings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: taggings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE taggings_id_seq OWNED BY taggings.id;


--
-- Name: tags; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE tags (
    id integer NOT NULL,
    name character varying(255)
);


--
-- Name: tags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: tags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE tags_id_seq OWNED BY tags.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    state character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    crypted_password character varying(255),
    password_salt character varying(255),
    persistence_token character varying(255),
    perishable_token character varying(255),
    login_count integer DEFAULT 0 NOT NULL,
    failed_login_count integer DEFAULT 0 NOT NULL,
    last_request_at timestamp without time zone,
    current_login_at timestamp without time zone,
    last_login_at timestamp without time zone,
    current_login_ip character varying(255),
    last_login_ip character varying(255),
    admin boolean DEFAULT false,
    site_id integer NOT NULL,
    account_id integer NOT NULL,
    score integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: wave_to_posting_migration_logs; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE wave_to_posting_migration_logs (
    id integer NOT NULL,
    wave_id integer,
    posting_id integer
);


--
-- Name: wave_to_posting_migration_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE wave_to_posting_migration_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: wave_to_posting_migration_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE wave_to_posting_migration_logs_id_seq OWNED BY wave_to_posting_migration_logs.id;


--
-- Name: waves_not_as_postings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE waves_not_as_postings (
    id integer NOT NULL,
    type character varying(255),
    slug character varying(255),
    user_id integer,
    topic character varying(255),
    description character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    resource_id integer,
    resource_type character varying(255),
    state character varying(255),
    postings_count integer DEFAULT 0
);


--
-- Name: waves_not_as_postings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE waves_not_as_postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: waves_not_as_postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE waves_not_as_postings_id_seq OWNED BY waves_not_as_postings.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY admin_tags ALTER COLUMN id SET DEFAULT nextval('admin_tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY assets ALTER COLUMN id SET DEFAULT nextval('assets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY biometric_people_values ALTER COLUMN id SET DEFAULT nextval('biometric_people_values_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY bookmarks ALTER COLUMN id SET DEFAULT nextval('bookmarks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY delayed_jobs ALTER COLUMN id SET DEFAULT nextval('delayed_jobs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendships ALTER COLUMN id SET DEFAULT nextval('friendships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitation_confirmations ALTER COLUMN id SET DEFAULT nextval('invitation_confirmations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY invitations ALTER COLUMN id SET DEFAULT nextval('invitations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY launch_users ALTER COLUMN id SET DEFAULT nextval('launch_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personages ALTER COLUMN id SET DEFAULT nextval('personages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY personas ALTER COLUMN id SET DEFAULT nextval('personas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY postings ALTER COLUMN id SET DEFAULT nextval('postings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY publications ALTER COLUMN id SET DEFAULT nextval('publications_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_embeds ALTER COLUMN id SET DEFAULT nextval('resource_embeds_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_events ALTER COLUMN id SET DEFAULT nextval('resource_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY resource_links ALTER COLUMN id SET DEFAULT nextval('resource_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signal_categories ALTER COLUMN id SET DEFAULT nextval('signal_categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signal_categories_signals ALTER COLUMN id SET DEFAULT nextval('signal_categories_signals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY signals ALTER COLUMN id SET DEFAULT nextval('signals_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sites ALTER COLUMN id SET DEFAULT nextval('sites_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY stylesheets ALTER COLUMN id SET DEFAULT nextval('stylesheets_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY taggings ALTER COLUMN id SET DEFAULT nextval('taggings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY wave_to_posting_migration_logs ALTER COLUMN id SET DEFAULT nextval('wave_to_posting_migration_logs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY waves_not_as_postings ALTER COLUMN id SET DEFAULT nextval('waves_not_as_postings_id_seq'::regclass);


--
-- Name: accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);


--
-- Name: admin_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY admin_tags
    ADD CONSTRAINT admin_tags_pkey PRIMARY KEY (id);


--
-- Name: assets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY assets
    ADD CONSTRAINT assets_pkey PRIMARY KEY (id);


--
-- Name: biometric_people_values_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY biometric_people_values
    ADD CONSTRAINT biometric_people_values_pkey PRIMARY KEY (id);


--
-- Name: bookmarks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY bookmarks
    ADD CONSTRAINT bookmarks_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY delayed_jobs
    ADD CONSTRAINT delayed_jobs_pkey PRIMARY KEY (id);


--
-- Name: friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: invitation_confirmations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitation_confirmations
    ADD CONSTRAINT invitation_confirmations_pkey PRIMARY KEY (id);


--
-- Name: invitations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY invitations
    ADD CONSTRAINT invitations_pkey PRIMARY KEY (id);


--
-- Name: launch_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY launch_users
    ADD CONSTRAINT launch_users_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: personages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personages
    ADD CONSTRAINT personages_pkey PRIMARY KEY (id);


--
-- Name: postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY postings
    ADD CONSTRAINT postings_pkey PRIMARY KEY (id);


--
-- Name: publications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY publications
    ADD CONSTRAINT publications_pkey PRIMARY KEY (id);


--
-- Name: resource_embeds_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_embeds
    ADD CONSTRAINT resource_embeds_pkey PRIMARY KEY (id);


--
-- Name: resource_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_events
    ADD CONSTRAINT resource_events_pkey PRIMARY KEY (id);


--
-- Name: resource_links_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY resource_links
    ADD CONSTRAINT resource_links_pkey PRIMARY KEY (id);


--
-- Name: signal_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signal_categories
    ADD CONSTRAINT signal_categories_pkey PRIMARY KEY (id);


--
-- Name: signal_categories_signals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signal_categories_signals
    ADD CONSTRAINT signal_categories_signals_pkey PRIMARY KEY (id);


--
-- Name: signals_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY signals
    ADD CONSTRAINT signals_pkey PRIMARY KEY (id);


--
-- Name: sites_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: stylesheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY stylesheets
    ADD CONSTRAINT stylesheets_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: taggings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY taggings
    ADD CONSTRAINT taggings_pkey PRIMARY KEY (id);


--
-- Name: tags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: user_info_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY personas
    ADD CONSTRAINT user_info_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: wave_to_posting_migration_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY wave_to_posting_migration_logs
    ADD CONSTRAINT wave_to_posting_migration_logs_pkey PRIMARY KEY (id);


--
-- Name: waves_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY waves_not_as_postings
    ADD CONSTRAINT waves_pkey PRIMARY KEY (id);


--
-- Name: delayed_jobs_priority; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX delayed_jobs_priority ON delayed_jobs USING btree (priority, run_at);


--
-- Name: index_assets_on_name_and_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assets_on_name_and_type ON assets USING btree (name, type);


--
-- Name: index_assets_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_assets_on_type ON assets USING btree (type);


--
-- Name: index_biometric_people_values_on_person_id_and_domain_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_biometric_people_values_on_person_id_and_domain_id ON biometric_people_values USING btree (person_id, domain_id);


--
-- Name: index_bookmarks_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bookmarks_on_user_id ON bookmarks USING btree (user_id);


--
-- Name: index_bookmarks_on_wave_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_bookmarks_on_wave_id_and_user_id ON bookmarks USING btree (wave_id, user_id);


--
-- Name: index_friendships_on_type_and_friend_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_friendships_on_type_and_friend_id ON friendships USING btree (type, friend_id);


--
-- Name: index_friendships_on_type_and_user_id_and_friend_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_friendships_on_type_and_user_id_and_friend_id ON friendships USING btree (type, user_id, friend_id);


--
-- Name: index_notifications_on_posting_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_posting_id ON notifications USING btree (posting_id);


--
-- Name: index_notifications_on_user_id_and_posting_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_notifications_on_user_id_and_posting_id ON notifications USING btree (user_id, posting_id);


--
-- Name: index_postings_on_parent_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_postings_on_parent_id ON postings USING btree (parent_id);


--
-- Name: index_postings_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_postings_on_resource_id_and_resource_type ON postings USING btree (resource_id, resource_type);


--
-- Name: index_postings_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_postings_on_user_id ON postings USING btree (user_id);


--
-- Name: index_signal_categories_on_site_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_signal_categories_on_site_id ON signal_categories USING btree (site_id);


--
-- Name: index_signal_categories_signals_on_category_id_and_signal_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_signal_categories_signals_on_category_id_and_signal_id ON signal_categories_signals USING btree (category_id, signal_id);


--
-- Name: index_signals_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_signals_on_name ON signals USING btree (name);


--
-- Name: index_sites_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_sites_on_name ON sites USING btree (name);


--
-- Name: index_sites_users_on_site_id_and_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_users_on_site_id_and_user_id ON sites_users USING btree (site_id, user_id);


--
-- Name: index_sites_users_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_users_on_user_id ON sites_users USING btree (user_id);


--
-- Name: index_sites_waves_on_site_id_and_wave_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_waves_on_site_id_and_wave_id ON sites_waves USING btree (site_id, wave_id);


--
-- Name: index_sites_waves_on_wave_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sites_waves_on_wave_id ON sites_waves USING btree (wave_id);


--
-- Name: index_stylesheets_on_site_id_and_controller_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_stylesheets_on_site_id_and_controller_name ON stylesheets USING btree (site_id, controller_name);


--
-- Name: index_subscriptions_on_user_id_resource_id_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_subscriptions_on_user_id_resource_id_resource_type ON subscriptions USING btree (user_id, resource_id, resource_type);


--
-- Name: index_taggings_on_tag_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_tag_id ON taggings USING btree (tag_id);


--
-- Name: index_taggings_on_taggable_id_and_taggable_type_and_context; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_taggings_on_taggable_id_and_taggable_type_and_context ON taggings USING btree (taggable_id, taggable_type, context);


--
-- Name: index_user_info_on_first_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_info_on_first_name ON personas USING btree (first_name);


--
-- Name: index_user_info_on_handle; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_info_on_handle ON personas USING btree (handle);


--
-- Name: index_users_on_account_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_account_id ON users USING btree (account_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_last_request_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_last_request_at ON users USING btree (last_request_at);


--
-- Name: index_users_on_persistence_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_users_on_persistence_token ON users USING btree (persistence_token);


--
-- Name: index_users_on_site_id_and_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_site_id_and_email ON users USING btree (site_id, email);


--
-- Name: index_waves_on_resource_id_and_resource_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_waves_on_resource_id_and_resource_type ON waves_not_as_postings USING btree (resource_id, resource_type);


--
-- Name: index_waves_on_type; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_waves_on_type ON waves_not_as_postings USING btree (type);


--
-- Name: index_waves_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_waves_on_user_id ON waves_not_as_postings USING btree (user_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

INSERT INTO schema_migrations (version) VALUES ('20100224010020');

INSERT INTO schema_migrations (version) VALUES ('20100411000000');

INSERT INTO schema_migrations (version) VALUES ('20100414000439');

INSERT INTO schema_migrations (version) VALUES ('20100414010000');

INSERT INTO schema_migrations (version) VALUES ('20100414020000');

INSERT INTO schema_migrations (version) VALUES ('20100423145633');

INSERT INTO schema_migrations (version) VALUES ('20100424231702');

INSERT INTO schema_migrations (version) VALUES ('20100427024309');

INSERT INTO schema_migrations (version) VALUES ('20101101042055');

INSERT INTO schema_migrations (version) VALUES ('20101121113309');

INSERT INTO schema_migrations (version) VALUES ('20101122105517');

INSERT INTO schema_migrations (version) VALUES ('20101127044526');

INSERT INTO schema_migrations (version) VALUES ('20101210232026');

INSERT INTO schema_migrations (version) VALUES ('20101217130324');

INSERT INTO schema_migrations (version) VALUES ('20110107003456');

INSERT INTO schema_migrations (version) VALUES ('20110107175236');

INSERT INTO schema_migrations (version) VALUES ('20110107175437');

INSERT INTO schema_migrations (version) VALUES ('20110122013406');

INSERT INTO schema_migrations (version) VALUES ('20110127032342');

INSERT INTO schema_migrations (version) VALUES ('20110204025404');

INSERT INTO schema_migrations (version) VALUES ('20110204025607');

INSERT INTO schema_migrations (version) VALUES ('20110218014859');

INSERT INTO schema_migrations (version) VALUES ('20110316042214');

INSERT INTO schema_migrations (version) VALUES ('20110320224444');

INSERT INTO schema_migrations (version) VALUES ('20110324064641');

INSERT INTO schema_migrations (version) VALUES ('20110409075604');

INSERT INTO schema_migrations (version) VALUES ('20110525054823');

INSERT INTO schema_migrations (version) VALUES ('20110526122102');

INSERT INTO schema_migrations (version) VALUES ('20110604222733');

INSERT INTO schema_migrations (version) VALUES ('20110608054950');

INSERT INTO schema_migrations (version) VALUES ('20110625221836');

INSERT INTO schema_migrations (version) VALUES ('20110706041458');

INSERT INTO schema_migrations (version) VALUES ('20110819082422');

INSERT INTO schema_migrations (version) VALUES ('20110920044710');

INSERT INTO schema_migrations (version) VALUES ('20110921065942');

INSERT INTO schema_migrations (version) VALUES ('20111012141253');

INSERT INTO schema_migrations (version) VALUES ('20111105191146');

INSERT INTO schema_migrations (version) VALUES ('20111117220256');

INSERT INTO schema_migrations (version) VALUES ('20111124235307');

INSERT INTO schema_migrations (version) VALUES ('20111126042105');

INSERT INTO schema_migrations (version) VALUES ('20111203202538');

INSERT INTO schema_migrations (version) VALUES ('20111211080912');

INSERT INTO schema_migrations (version) VALUES ('20111212061640');

INSERT INTO schema_migrations (version) VALUES ('20111220232854');

INSERT INTO schema_migrations (version) VALUES ('20111221013846');

INSERT INTO schema_migrations (version) VALUES ('20111222002947');

INSERT INTO schema_migrations (version) VALUES ('20120124032044');

INSERT INTO schema_migrations (version) VALUES ('20120125023326');

INSERT INTO schema_migrations (version) VALUES ('20120217063032');

INSERT INTO schema_migrations (version) VALUES ('20120224002944');

INSERT INTO schema_migrations (version) VALUES ('20120229021446');

INSERT INTO schema_migrations (version) VALUES ('20120302003118');

INSERT INTO schema_migrations (version) VALUES ('20120305234120');

INSERT INTO schema_migrations (version) VALUES ('20120321040306');

INSERT INTO schema_migrations (version) VALUES ('20120324233726');

INSERT INTO schema_migrations (version) VALUES ('20120425032937');

INSERT INTO schema_migrations (version) VALUES ('20120818235248');

INSERT INTO schema_migrations (version) VALUES ('20121222215843');