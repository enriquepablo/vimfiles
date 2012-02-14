import vim
from gdata import service
import gdata
import atom
import subprocess
from lxml import etree, html


class BloggerClient(object):

    def __init__(self, username, password):
        self.service = service.GDataService(username, password)
        self.service.source = 'vim-blogger.0.1'
        self.service.service = 'blogger'
        self.service.account_type = 'GOOGLE'
        self.service.server = 'www.blogger.com'
        self.service.ProgrammaticLogin()
        query = service.Query()
        query.feed = '/feeds/default/blogs'
        feed = self.service.Get(query.ToUri())
        self.blog_id = None
        self.blogs = []
        self.post_id = 0
        self.posts = None
        for entry in feed.entry:
            blog_id = entry.GetSelfLink().href.split("/")[-1]
            self.blogs.append({'id': blog_id, 'title': entry.title.text})

    def choose_blog(self):
        if not len(self.blogs):
            print 'You have no blogs to index'
            return
        for n, blog in enumerate(self.blogs):
            print '%d: %s' % (n, blog['title'])
        while True:
            vim.command('let choice = input("Enter blog number: ")')
            choice = vim.eval('choice')
            if choice.isdigit():
                blog = self.blogs[int(choice)]
                self.blog_id = blog['id']
                self.posts = None
                break
        self.choose_post()

    def get_posts(self, categories=None, start_date=None, end_date=None):
        if self.blog_id is None:
            self.choose_blog()
        query = service.Query()
        query.feed = '/feeds/%s/posts/default' % self.blog_id
        if categories:
            query.categories = categories
        if start_date:
            query.updated_min = start_date
        if end_date:
            query.updated_max = end_date
        query.max_results = 9
        feed = self.service.Get(query.ToUri())
        self.posts = feed.entry

    def choose_post(self):
        if self.posts is None:
            self.get_posts()
        print '0: new post'
        for n, post in enumerate(self.posts):
            print '%d: %s' % (n + 1, post.title.text)
        while True:
            vim.command('let choice = input("Enter a post number: ")')
            choice = vim.eval('choice')
            if choice.isdigit():
                self.post_id = int(choice)
                break
        title = 'title'
        raw = 'body'
        category = ''
        if self.post_id:
            post = self.posts[self.post_id - 1]
            raw = post.content.text.decode('utf8')
            parser = etree.HTMLParser(encoding='utf8', remove_blank_text=True)
            html_e = etree.HTML(raw, parser=parser)
            try:
                body_elem = html_e.xpath('//pre[@id="rest-vim-source"]')[0]
                raw = body_elem.text
            except IndexError:
                pass
            title = post.title.text
            category = ', '.join([cat.term for cat in post.category])
        vim.command('e _index.rst')
        vim.command('set nomodified')
        vim.current.buffer[:] = []
        vim.command('set encoding=utf-8')
        vim.current.buffer[0] = title
        vim.current.buffer.append('')
        for line in raw.split('\n'):
            vim.current.buffer.append(line.encode('utf8'))
        vim.current.buffer.append('')
        vim.current.buffer.append('labels: ' + category)
        vim.command('set nomodified')

    def save_post(self):
        title = vim.current.buffer[0]
        rest = '\n'.join(vim.current.buffer[2:-2])
        labels = vim.current.buffer[-1][8:].split(',')
        category = [atom.Category(term=l.strip().decode('utf8'),
                                  scheme="http://www.blogger.com/atom/ns#") \
                    for l in labels]
        f = open('index.rst', 'w')
        f.write(rest)
        f.close()
        retval = subprocess.call(['make', 'html'])
        if retval != 0:
            print 'Error building html'
            return
        html_f = open('_build/html/index.html')
        body = html_f.read()
        html_f.close()
        parser = etree.HTMLParser(encoding='utf8', remove_blank_text=True)
        html_e = etree.HTML(body.decode('utf8'), parser=parser)
        blockquotes = html_e.xpath('//blockquote')
        for bq in blockquotes:
            for children in bq.iterchildren():
                bq.addprevious(children)
            parent = bq.getparent()
            parent.remove(bq)
        rest_elem = html_e.xpath('//pre[@id="rest-vim-source"]')[0]
        rest_elem.text = rest.decode('utf8')
        title = atom.Title('xhtml', title.decode('utf8'))
        content = atom.Content(content_type='html',
                               text=html.tostring(html_e, encoding=unicode))
        if self.post_id:
            post = self.posts[self.post_id - 1]
        else:
            post = gdata.GDataEntry()
        control = atom.Control()
        control.draft = atom.Draft(text='yes')
        post.control = control
        post.title = title
        post.content = content
        post.category = category
        if self.post_id:
            try:
                self.service.Put(post, post.GetEditLink().href)
            except Exception, e:
                print 'Error: ' + str(e)
            else:
                vim.command('set nomodified')
                print 'Post successful'
        else:
            try:
                new_post = self.service.Post(post,
                        '/feeds/%s/posts/default' % self.blog_id)
            except Exception, e:
                print 'Error: ' + str(e)
            else:
                self.posts.append(new_post)
                self.post_id = len(self.posts)
                vim.command('set nomodified')
                print 'Post successful'


blogger_client = None

def get_client():
    global blogger_client
    if blogger_client is None:
        username = vim.eval('g:Gmail_Account')
        password = vim.eval('g:Gmail_Password')
        try:
            blogger_client = BloggerClient(username, password)
        except Exception, e:
            print "ERROR: " + str(e)
    return blogger_client
