ALTER TABLE projects ADD COLUMN is_released BOOLEAN DEFAULT false;

CREATE TABLE public.docs (
    id integer NOT NULL,
    project_id integer,
    live_build_id integer,
    domain character varying,
    config json,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);

CREATE SEQUENCE public.docs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.docs_id_seq OWNED BY public.docs.id;
ALTER TABLE ONLY public.docs ALTER COLUMN id SET DEFAULT nextval('public.docs_id_seq'::regclass);

CREATE TABLE public.doc_builds (
    id integer NOT NULL,
    doc_id integer,
    app_version character varying,
    status json,
    config json,
    created_at timestamp without time zone
);

CREATE SEQUENCE public.doc_builds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.doc_builds_id_seq OWNED BY public.doc_builds.id;

CREATE FUNCTION public.trigger_set_project_file_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF NEW.created_at IS NULL then
                NEW.created_at = NOW();
            END IF;

            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $$;



CREATE TABLE public.project_files (
    id integer primary key,
    project_id integer references projects(id),
    path character varying NOT NULL,
    branch character varying NOT NULL,
    spec character varying,
    lang character varying,
    size integer,
    contents character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);



CREATE SEQUENCE public.project_files_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.project_files_id_seq OWNED BY public.project_files.id;
ALTER TABLE ONLY public.project_files ALTER COLUMN id SET DEFAULT nextval('public.project_files_id_seq'::regclass);
ALTER TABLE ONLY public.project_files ADD CONSTRAINT project_files_pkey PRIMARY KEY (id);
CREATE INDEX index_project_files_on_project_id ON public.project_files USING btree (project_id);
CREATE TRIGGER trigger_set_project_file_timestamp BEFORE INSERT OR UPDATE ON public.project_files FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_project_file_timestamp();
ALTER TABLE ONLY public.project_files ADD CONSTRAINT fk_rails_c26fbba4b3 FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;

CREATE FUNCTION public.trigger_set_post_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF NEW.created_at IS NULL then
                NEW.created_at = NOW();
            END IF;

            NEW.updated_at = NOW();
            RETURN NEW;
        END;
        $$;



CREATE FUNCTION public.trigger_set_post_iid() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            SELECT COALESCE(MAX(iid) + 1, 1)
            INTO NEW.iid
            FROM posts
            WHERE project_id = NEW.project_id;

            RETURN NEW;
        END;
        $$;



CREATE FUNCTION public.trigger_set_post_last_activity_at_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF (TG_OP = 'INSERT') THEN
              UPDATE posts
              SET last_activity_at = NOW()
              WHERE NEW.parent_type = 'post' AND id = NEW.parent_id;
            ELSIF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
              UPDATE posts
              SET last_activity_at = NOW()
              WHERE OLD.parent_type = 'post' AND id = OLD.parent_id;
            END IF;

            RETURN NEW;
        END;
        $$;



CREATE TABLE public.posts (
    id integer NOT NULL,
    iid integer NOT NULL,
    project_id integer NOT NULL,
    creator_id integer NOT NULL,
    file_id integer,
    state character varying DEFAULT 'open'::character varying NOT NULL,
    type character varying NOT NULL,
    title character varying,
    body character varying,
    file_loc character varying,
    last_activity_at timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);



CREATE SEQUENCE public.posts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.posts_id_seq OWNED BY public.posts.id;
ALTER TABLE ONLY public.posts ALTER COLUMN id SET DEFAULT nextval('public.posts_id_seq'::regclass);
ALTER TABLE ONLY public.posts ADD CONSTRAINT posts_pkey PRIMARY KEY (id);
CREATE INDEX index_posts_on_created_at ON public.posts USING btree (created_at);
CREATE INDEX index_posts_on_creator_id ON public.posts USING btree (creator_id);
CREATE INDEX index_posts_on_file_id ON public.posts USING btree (file_id);
CREATE UNIQUE INDEX index_posts_on_project_id_and_iid ON public.posts USING btree (project_id, iid);
CREATE INDEX index_posts_on_state ON public.posts USING btree (state);
CREATE TRIGGER trigger_set_post_iid BEFORE INSERT ON public.posts FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_post_iid();
CREATE TRIGGER trigger_set_post_last_activity_at BEFORE INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_post_last_activity_at();
CREATE TRIGGER trigger_set_post_timestamp BEFORE INSERT OR UPDATE ON public.posts FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_post_timestamp();
ALTER TABLE ONLY public.posts ADD CONSTRAINT fk_rails_4037146b6f FOREIGN KEY (creator_id) REFERENCES public.users(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.posts ADD CONSTRAINT fk_rails_8736f5867f FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;
ALTER TABLE ONLY public.posts ADD CONSTRAINT fk_rails_b46651c12e FOREIGN KEY (file_id) REFERENCES public.project_files(id) ON DELETE CASCADE;

CREATE FUNCTION public.trigger_set_post_last_activity_at_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF (TG_OP = 'INSERT') THEN
              UPDATE posts
              SET last_activity_at = NOW()
              WHERE NEW.parent_type = 'post' AND id = NEW.parent_id;
            ELSIF (TG_OP = 'DELETE' OR TG_OP = 'UPDATE') THEN
              UPDATE posts
              SET last_activity_at = NOW()
              WHERE OLD.parent_type = 'post' AND id = OLD.parent_id;
            END IF;

            RETURN NEW;
        END;
        $$;



CREATE FUNCTION public.trigger_set_comment_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
        BEGIN
            IF NEW.created_at IS NULL then
                NEW.created_at = NOW();
            END IF;

          NEW.updated_at = NOW();
          RETURN NEW;
        END;
        $$;



CREATE TABLE public.comments (
    id integer NOT NULL,
    creator_id integer NOT NULL,
    parent_id integer NOT NULL,
    parent_type character varying NOT NULL,
    body character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);



CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;
ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);
ALTER TABLE ONLY public.comments ADD CONSTRAINT comments_pkey PRIMARY KEY (id);
CREATE INDEX index_comments_on_created_at ON public.comments USING btree (created_at);
CREATE INDEX index_comments_on_parent_type_and_parent_id ON public.comments USING btree (parent_type, parent_id);
CREATE TRIGGER trigger_set_comment_timestamp BEFORE INSERT OR UPDATE ON public.comments FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_comment_timestamp();
CREATE TRIGGER trigger_set_post_last_activity_at_comments BEFORE INSERT OR DELETE OR UPDATE ON public.comments FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_post_last_activity_at_comments();

CREATE OR REPLACE FUNCTION trigger_set_created_at()
RETURNS trigger AS
$BODY$
BEGIN
    IF NEW.created_at IS NULL then
    NEW.created_at = NOW();
    END IF;
    RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql'
VOLATILE;
CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS trigger AS
$BODY$
BEGIN
    IF NEW.created_at IS NULL then
    NEW.created_at = NOW();
    END IF;
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$BODY$
LANGUAGE 'plpgsql'
VOLATILE;

CREATE TRIGGER trigger_set_timestamp BEFORE INSERT OR UPDATE ON public.docs FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_timestamp();
CREATE SEQUENCE public.doc_builds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
ALTER SEQUENCE public.doc_builds_id_seq OWNED BY public.doc_builds.id;
ALTER TABLE ONLY public.doc_builds ALTER COLUMN id SET DEFAULT nextval('public.doc_builds_id_seq'::regclass);
ALTER TABLE ONLY public.doc_builds
    ADD CONSTRAINT doc_builds_pkey PRIMARY KEY (id);
CREATE INDEX index_doc_builds_on_doc_id ON public.doc_builds USING btree (doc_id);
ALTER TABLE ONLY public.doc_builds
    ADD CONSTRAINT doc_builds_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES public.docs(id) ON DELETE CASCADE;

CREATE TRIGGER trigger_set_created_at BEFORE INSERT ON public.doc_builds FOR EACH ROW EXECUTE PROCEDURE public.trigger_set_created_at();
ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.posts(id) ON DELETE CASCADE NOT VALID;
ALTER TABLE ONLY public.docs
    ADD CONSTRAINT docs_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE NOT VALID;

ALTER TABLE ONLY public.doc_builds
    ADD CONSTRAINT doc_builds_doc_id_fkey FOREIGN KEY (doc_id) REFERENCES public.docs(id) ON DELETE CASCADE;

CREATE INDEX index_docs_on_project_id ON public.docs USING btree (project_id);
CREATE UNIQUE INDEX index_docs_on_domain ON public.docs USING btree (domain);

ALTER TABLE ONLY public.docs
    ADD CONSTRAINT docs_pkey PRIMARY KEY (id);
