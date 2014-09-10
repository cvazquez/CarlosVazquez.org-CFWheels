CREATE DATABASE cvazquezblogcake;

DROP VIEW cvazquezblogcake.posts;
CREATE DEFINER = `blog_view_user`@`localhost`
    SQL SECURITY DEFINER
    VIEW cvazquezblogcake.posts (`id`, `post_id`, `title`, `teaser`, `body`, `metaDescription`, `metaKeyWords`, `publishAt`, `created`, `createdBy`, `modified`, `updatedBy`, `deletedAt`, `deletedBy`, `timestampAt`)
    AS 
	 SELECT `id`, `entryId`, `title`, `teaser`, `content`, `metaDescription`, `metaKeyWords`, `publishAt`, `createdAt`, `createdBy`, `updatedAt`, `updatedBy`, `deletedAt`, `deletedBy`, `timestampAt`
	 FROM cvazquezblog.entries
    WITH  CHECK OPTION;
    
GRANT SELECT ON cvazquezblogcake.posts TO 'cakeUser'@'localhost';

GRANT SELECT ON cvazquezblog.entries TO blog_view_user@localhost;
    
SELECT * from cvazquezblogcake.posts
limit 10;


DROP VIEW IF EXISTS cvazquezblogcake.categories;
CREATE DEFINER = `blog_view_user`@`localhost`
    SQL SECURITY DEFINER
    VIEW cvazquezblogcake.categories (`id`, `category_id`, `name`, `created`, `createdBy`, `modified`, `updatedBy`, `deletedAt`, `deletedBy`, `timestampAt`)
    AS 
	 SELECT `id`, `categoryId`, `name`, `createdAt`, `createdBy`, `updatedAt`, `updatedBy`, `deletedAt`, `deletedBy`, `timestampAt`
	 FROM cvazquezblog.categories
    WITH  CHECK OPTION;
    
GRANT SELECT ON cvazquezblogcake.categories TO 'cakeUser'@'localhost';
show grants for 'cakeUser'@'localhost';

GRANT SELECT ON cvazquezblog.categories TO blog_view_user@localhost;


DROP VIEW IF EXISTS cvazquezblogcake.categories_posts;
CREATE DEFINER = `blog_view_user`@`localhost`
    SQL SECURITY DEFINER
    VIEW cvazquezblogcake.categories_posts (`id`, `post_id`, `category_id`, `created`, `createdBy`, `modified`, `updatedBy`, `deletedAt`, `deletedBy`, `timestampAt`)
    AS 
	 SELECT `id`, `entryId`, `categoryId`, `createdAt`, `createdBy`, `updatedAt`, `updatedBy`, `deletedAt`, `deletedBy`, `timestampAt`
	 FROM cvazquezblog.entrycategories
    WITH  CHECK OPTION;

#revoke delete ON cvazquezblogcake.categories_posts from 'cakeUser'@'localhost';
#revoke delete ON cvazquezblog.entrycategories from blog_view_user@localhost;
GRANT SELECT, DELETE, INSERT ON cvazquezblogcake.categories_posts TO 'cakeUser'@'localhost';
GRANT SELECT, DELETE, INSERT ON cvazquezblog.entrycategories TO blog_view_user@localhost;

show grants for 'cakeUser'@'localhost';
