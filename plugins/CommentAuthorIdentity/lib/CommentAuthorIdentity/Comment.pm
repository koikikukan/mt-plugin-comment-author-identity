package CommentAuthorIdentity::Comment;

use strict;

sub _hdlr_comment_author_identity {
    my ($ctx, $args) = @_;
    my $cmt = $ctx->stash('comment')
         or return $ctx->_no_comment_error();
    my $cmntr = $ctx->stash('commenter');
    unless ($cmntr) {
        if ($cmt->commenter_id) {
            $cmntr = MT::Author->load($cmt->commenter_id) 
                or return "";
        } else {
            return q();
        }
    }
    my $link = $cmntr->url;
    my $static_path = $ctx->invoke_handler('StaticWebPath', $args);
    my $logo = $cmntr->auth_icon_url;
    unless ($logo) {
        my $root_url = $static_path . "images";
        $logo = "$root_url/nav-commenters.gif";
    }
    if ($logo =~ m!^/!) {
        # relative path, prepend blog domain
        my $blog = $ctx->stash('blog');
        if ($blog) {
            my ($blog_domain) = $blog->archive_url =~ m|(.+://[^/]+)|;
            $logo = $blog_domain . $logo;
        }
    }
    my $alt = $args->{alt} || 'logo';
    my $title = $args->{title} || 'commenter logo';
    my $result = qq{<img alt=\"$alt\" title=\"$title\" src=\"$logo\" width=\"16\" height=\"16\" />};
    if ($link) {
        $result = qq{<a class="commenter-profile" href=\"$link\">$result</a>};
    }
    return $result;
}

1;
