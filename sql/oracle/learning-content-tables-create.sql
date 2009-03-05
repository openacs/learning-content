--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--
--
-- Oracle port samir@symphinity.com 11 July 2002
--

-- table to differentiate between normal pages and activity pages inside content
create table content_activities 
(
    item_id         number(38) constraint pk_content_activities primary key,
    activity_id     number(38)
);
-- table to track how many times a word of the glossary is being used in every content page
create table content_glossary_term_count
(
    term            varchar2(400)    not null,
    page            varchar2(400)    not null,
    folder_id       number(38)       not null,
    times_used      number(38),
    constraint pk_content_glossary_count     primary key (term,page,folder_id)
);

