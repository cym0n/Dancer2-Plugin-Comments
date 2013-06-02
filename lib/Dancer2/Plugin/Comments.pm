package Dancer2::Plugin::Comments;
use Dancer ':syntax';
use Dancer2::Plugin;
use Data::Dumper;
use Module::Load;


register 'commentbox' => sub {
    my $conf = generate_config();
    my $box = '<form id="'. $conf->{'css_box_id'} .'" action="'.$conf->{'post_route'}.'" method="post">';
    if($conf->{'author'} == 1)
    { 
        $box .= '<p><input type="text" name="author" /><label for="author">' . $conf->{'author_label'} . '</label></p>';
    }
    if($conf->{'mail'})
    {    
        $box .= '<p><input type="text" name="mail" /><label for="mail">' . $conf->{'mail_label'} . '</label></p>';
    }
    if($conf->{'site'})
    {    
        $box .= '<p><input type="text" name="site" /><label for="site">' . $conf->{'site_label'} . '</label></p>';
    }
    $box .= '<p><textarea rows=3 style="width:100%" name="comment"></textarea></p>' . 
            '<p><input type="submit" /></p></form>';
    return $box;
};

register 'comments' => sub {
    my $dsl = shift;
    my $conf = generate_config();
    my $reference = $dsl->request->path;
    my $handler_class = 'Dancer2::Plugin::Comments::Handler::'. $conf->{'handler'};
    eval { load $handler_class };
    my $handler = $handler_class->new({'conf' => $conf, 'dsl' => $dsl});
    my @comments = $handler->get_comments($reference);
    my $fe_code = '<div id="'.$conf->{'css_list_id'}.'"><ul>';
    foreach(@comments)
    {
        my $c = $_;
        if($c)
        {
            $fe_code .= '<li><span class="author">'.$c->{'author'}.'</span>'; 
            $fe_code .= '<span class="comment">' . $c->{'text'}.'</span>';
            $fe_code .= '<span class="timestamp">' . $c->{'timestamp'} .'</span></li>';
        }
    }
    $fe_code .= '</div></ul>';
    return $fe_code; 
};


on_plugin_import {
    my $dsl = shift;
    my $conf = generate_config();

    my $comment_route = sub {
        my $comment = params->{'comment'};
        my $author = params->{'author'};
        my $mail = params->{'mail'};
        my $site = params->{'site'};
        my $referer = $dsl->request->referer;
        my $referer_call = $referer;
        $referer_call =~ s!^http://.*?/!/!;
        my $commit = {author => $author, text => $comment, page => $referer_call};
        $commit->{'mail'} = $mail if $conf->{'mail'};
        $commit->{'site'} = $site if $conf->{'site'};
        my $handler_class = 'Dancer2::Plugin::Comments::Handler::'. $conf->{'handler'};
        eval { load $handler_class };
        my $handler = $handler_class->new({'conf' => $conf, 'dsl' => $dsl});
        $handler->write_comment($commit);
        redirect $referer;
    };

    $dsl->any(['post'] => $conf->{'post_route'}, $comment_route);


};

#Plugin settings wrapped here for default values management
sub generate_config
{
    my $conf = plugin_setting();
    $conf->{'handler'} ||= "DBIC";
    $conf->{'db_class'} ||= "Comment";
    $conf->{'post_route'} ||= "/comment";
    $conf->{'css_box_id'} ||= "commentsbox";
    $conf->{'css_list_id'} ||= "comments";
    $conf->{'author_label'} ||= "Author";
    $conf->{'mail_label'} ||= "Mail";
    $conf->{'site_label'} ||= "Site";
    #If author is off no mail or site should be requested
    if($conf->{'author'} == 0)
    {
        $conf->{'mail'} = 0;
        $conf->{'site'} = 0;
    }
    else
    {
        $conf->{'author'} = 1;
    }
    return $conf;
}



register_plugin for_versions => [ 2 ];

1;
