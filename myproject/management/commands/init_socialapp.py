import os
from django.core.management.base import BaseCommand

class Command(BaseCommand):
    help = 'Create/update Google SocialApp from env vars (GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET)'

    def handle(self, *args, **options):
        try:
            from allauth.socialaccount.models import SocialApp
            from django.contrib.sites.models import Site
        except Exception as e:
            self.stderr.write('Error importing allauth models: %s' % e)
            return

        client_id = os.environ.get('GOOGLE_CLIENT_ID')
        client_secret = os.environ.get('GOOGLE_CLIENT_SECRET')
        if not client_id or not client_secret:
            self.stderr.write('Please set GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET environment variables.')
            return

        site = Site.objects.get_current()
        app, created = SocialApp.objects.get_or_create(provider='google', defaults={'name': 'Google', 'client_id': client_id, 'secret': client_secret})
        if not created:
            app.client_id = client_id
            app.secret = client_secret
            app.save()

        if site not in app.sites.all():
            app.sites.add(site)

        app.save()
        self.stdout.write('Google SocialApp created or updated for site %s' % site.domain)
