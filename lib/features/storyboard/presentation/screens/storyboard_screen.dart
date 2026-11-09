import 'package:flutter/material.dart';
import '../../../../core/design/design_tokens.dart';

const _storyBlue = Color(0xFF146EF5);
const _storyNavy = Color(0xFF092A4A);
const _storyGreen = Color(0xFF16A66A);
const _storyAmber = Color(0xFFF59E0B);
const _blue = _storyBlue;
const _navy = _storyNavy;
const _green = _storyGreen;
const _amber = _storyAmber;

class StoryboardScreen extends StatelessWidget {
  const StoryboardScreen({super.key});

  static const _blue = Color(0xFF146EF5);
  static const _navy = Color(0xFF092A4A);
  static const _green = Color(0xFF16A66A);
  static const _amber = Color(0xFFF59E0B);
  static const _red = Color(0xFFDC3545);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      appBar: AppBar(
        title: const Text('MboaPOS · Storyboard'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1320),
            child: Column(
              children: [
                _BoardHeader(),
                const SizedBox(height: AppSpacing.xl),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final columns = constraints.maxWidth >= 1050
                        ? 5
                        : constraints.maxWidth >= 700
                            ? 4
                            : constraints.maxWidth >= 470
                                ? 3
                                : 2;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: columns,
                        crossAxisSpacing: AppSpacing.lg,
                        mainAxisSpacing: AppSpacing.xl,
                        childAspectRatio: 0.49,
                      ),
                      itemCount: _screens.length,
                      itemBuilder: (context, index) {
                        final screen = _screens[index];
                        return _StoryboardCard(
                          number: index + 1,
                          title: screen.title,
                          child: screen.builder(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static final List<_StoryboardScreen> _screens = [
    _StoryboardScreen('Splash', _splash),
    _StoryboardScreen('Onboarding 1', _onboardingOne),
    _StoryboardScreen('Onboarding 2', _onboardingTwo),
    _StoryboardScreen('Onboarding 3', _onboardingThree),
    _StoryboardScreen('Connexion', _login),
    _StoryboardScreen('Créer un compte', _createAccount),
    _StoryboardScreen('Choix du rôle', _role),
    _StoryboardScreen('Entreprise', _business),
    _StoryboardScreen('Accueil propriétaire', _ownerDashboard),
    _StoryboardScreen('Accueil caissière', _staffDashboard),
    _StoryboardScreen('Stock', _stock),
    _StoryboardScreen('Détail produit', _productDetails),
    _StoryboardScreen('Nouvelle vente', _newSale),
    _StoryboardScreen('Rapports', _reports),
    _StoryboardScreen('Paramètres', _settings),
    _StoryboardScreen('Mode hors connexion', _offline),
    _StoryboardScreen('Paiement', _payment),
    _StoryboardScreen('Vente réussie', _receipt),
    _StoryboardScreen('Historique des ventes', _history),
    _StoryboardScreen('Synchronisation', _syncCenter),
  ];

  static Widget _splash() => _Phone(
        background: _navy,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Logo(light: true),
            const SizedBox(height: 14),
            const Text('Gérez. Vendez. Grandissez.',
                style: TextStyle(color: Colors.white, fontSize: 9)),
            const Spacer(),
            _PrimaryButton('Commencer'),
            const SizedBox(height: 10),
            const Text('Se connecter',
                style: TextStyle(color: Colors.white, fontSize: 9)),
          ],
        ),
      );

  static Widget _onboardingOne() => _Onboarding(
        title: 'Votre point de vente toujours avec vous',
        text:
            'Vendez et gérez votre stock depuis votre téléphone, même sans connexion.',
        icon: Icons.storefront_outlined,
        page: 0,
        button: 'Suivant',
      );

  static Widget _onboardingTwo() => _Onboarding(
        title: 'Tout ce dont vous avez besoin, au même endroit',
        text:
            'Des outils simples pour prendre de meilleures décisions chaque jour.',
        icon: Icons.inventory_2_outlined,
        page: 1,
        button: 'Suivant',
        extra: Column(
          children: [
            _MiniFeature(Icons.inventory_2_outlined, 'Gestion de stock'),
            _MiniFeature(Icons.flash_on_outlined, 'Ventes rapides'),
            _MiniFeature(Icons.bar_chart_outlined, 'Rapports simples'),
          ],
        ),
      );

  static Widget _onboardingThree() => _Onboarding(
        title: 'Prêt à démarrer ?',
        text:
            'Rejoignez des commerces qui font confiance à MboaPOS pour vendre mieux.',
        icon: Icons.rocket_launch_outlined,
        page: 2,
        button: 'Commencer',
        secondary: 'Se connecter',
      );

  static Widget _login() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(back: true),
            _Logo(),
            const SizedBox(height: 12),
            _Title('Connectez-vous à votre espace'),
            const SizedBox(height: 16),
            _Field('Email ou numéro de téléphone', Icons.person_outline),
            _Field('Mot de passe', Icons.lock_outline,
                suffix: Icons.visibility_outlined),
            Row(children: [
              const Icon(Icons.check_box, size: 14, color: _blue),
              const SizedBox(width: 4),
              const Text('Se souvenir de moi', style: TextStyle(fontSize: 8)),
              const Spacer(),
              Text('Mot de passe oublié ?',
                  style: TextStyle(fontSize: 8, color: _blue)),
            ]),
            const SizedBox(height: 14),
            _PrimaryButton('Se connecter'),
            _Divider('Ou continuer avec'),
            _OutlineButton('Continuer avec Google', icon: Icons.g_mobiledata),
            const Spacer(),
            _Link('Créer mon espace'),
          ],
        ),
      );

  static Widget _createAccount() => _FormScreen(
        title: 'Créer votre espace',
        fields: [
          _Field('Nom', Icons.person_outline),
          _Field('Nom de votre boutique', Icons.storefront_outlined),
          _Field('Pays', Icons.public),
          _Field('Email', Icons.email_outlined),
          _Field('+237  Numéro de téléphone', Icons.phone_outlined),
          _Field('Mot de passe', Icons.lock_outline),
        ],
        button: 'Créer mon compte',
        footer:
            'En continuant, vous acceptez nos conditions et notre politique de confidentialité.',
      );

  static Widget _role() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(back: true),
            _Title('Quel est votre rôle ?'),
            _Muted('Cela nous aide à personnaliser votre expérience.'),
            const SizedBox(height: 16),
            _RoleCard(
                'Propriétaire / Gérant',
                'Accès complet à toutes les fonctionnalités',
                Icons.admin_panel_settings_outlined,
                true),
            _RoleCard(
                'Employé / Caissier',
                'Accès limité aux opérations de vente',
                Icons.point_of_sale_outlined,
                false),
            _RoleCard('Superviseur', 'Suivi et rapports uniquement',
                Icons.analytics_outlined, false),
            const Spacer(),
            _PrimaryButton('Continuer'),
          ],
        ),
      );

  static Widget _business() => _FormScreen(
        title: 'Créer votre entreprise',
        subtitle: 'Quelques informations pour configurer votre espace.',
        fields: [
          _Field('Nom de la boutique', Icons.storefront_outlined),
          _Field('Type de commerce', Icons.category_outlined,
              suffix: Icons.expand_more),
          _Field('Adresse', Icons.location_on_outlined),
          _Field('Devise  ·  XAF (Franc CFA)', Icons.payments_outlined,
              suffix: Icons.expand_more),
        ],
        button: 'Créer mon espace',
      );

  static Widget _ownerDashboard() => _Dashboard(
        name: 'Emmanuel',
        role: 'Ma boutique',
        total: '32 500 XAF',
        actions: const ['Vendre', 'Stock', 'Rapports', 'Clients'],
        popular: true,
      );

  static Widget _staffDashboard() => _Dashboard(
        name: 'Amina',
        role: 'Caissière',
        total: '18 750 XAF',
        actions: const ['Vendre', 'Mon stock'],
        popular: false,
      );

  static Widget _stock() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Stock', action: Icons.filter_list_outlined),
            _Search('Rechercher un produit...'),
            _Chips(['Tous', 'Catégories', 'Faible stock'], selected: 0),
            _Product('Eau minérale 0,5L', '500 XAF', 'Stock: 45',
                Icons.water_drop_outlined),
            _Product('Pain de mie', '1 200 XAF', 'Stock: 12',
                Icons.bakery_dining_outlined),
            _Product('Huile de palme', '900 XAF', 'Stock faible: 4',
                Icons.local_dining_outlined,
                warning: true),
            _Product('Savon Omo 500g', '750 XAF', 'Stock: 35',
                Icons.clean_hands_outlined),
            const Spacer(),
            Align(alignment: Alignment.bottomRight, child: _Fab(Icons.add)),
          ],
        ),
      );

  static Widget _productDetails() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Détails du produit', back: true),
            Container(
                height: 95,
                decoration: BoxDecoration(
                    color: const Color(0xFFEAF2FF),
                    borderRadius: AppRadius.card),
                child: const Icon(Icons.water_drop_outlined,
                    size: 52, color: _blue)),
            const SizedBox(height: 12),
            _Title('Eau minérale 0,5L'),
            _Price('500 XAF'),
            _Status('En stock · 45 unités', _green),
            const SizedBox(height: 14),
            _InfoRow('Catégorie', 'Boissons'),
            _InfoRow('Prix de vente', '500 XAF'),
            _InfoRow('Référence', 'EAU-050'),
            const Spacer(),
            Row(children: [
              _OutlineButton('Modifier'),
              const SizedBox(width: 8),
              Expanded(child: _PrimaryButton('Vendre'))
            ]),
          ],
        ),
      );

  static Widget _newSale() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Nouvelle vente'),
            _Search('Rechercher un produit...', scan: true),
            _Product('Eau minérale 0,5L', '500 XAF', '−  2  +',
                Icons.water_drop_outlined),
            _Product('Pain de mie', '1 200 XAF', '−  1  +',
                Icons.bakery_dining_outlined),
            const Spacer(),
            _Summary('Total', '2 200 XAF'),
            Row(children: [
              _OutlineButton('Vider'),
              const SizedBox(width: 8),
              Expanded(child: _PrimaryButton('Encaisser'))
            ]),
          ],
        ),
      );

  static Widget _reports() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Rapports'),
            _Chips(['Ventes', 'Stock', 'Produits'], selected: 0),
            _DateSelector(),
            _Title('Ventes du mois'),
            _Chart(),
            _Title('Meilleurs produits'),
            _Product('Eau minérale 0,5L', '24 ventes', '',
                Icons.water_drop_outlined),
            _Product(
                'Pain de mie', '18 ventes', '', Icons.bakery_dining_outlined),
          ],
        ),
      );

  static Widget _settings() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Paramètres'),
            _SettingGroup('Compte', ['Profil', 'Entreprise']),
            _SettingGroup(
                'Apparence', ['Thème  ·  Écran blanc', 'Langue  ·  Français']),
            _SettingGroup('Sécurité', ['Changer le mot de passe']),
            _SettingGroup('Aide', ['Aide et support']),
            const Spacer(),
            _OutlineButton('Se déconnecter', color: _red),
          ],
        ),
      );

  static Widget _offline() => _StatusScreen(
        title: 'Mode hors connexion',
        headline: 'Vous pouvez continuer à vendre',
        color: _amber,
        icon: Icons.cloud_off_outlined,
        rows: const [
          ('Ventes en attente', '3'),
          ('Stock local', 'À jour'),
          ('État', 'Synchronisation en attente'),
        ],
      );

  static Widget _payment() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Paiement', back: true),
            const SizedBox(height: 22),
            const Center(
                child: Text('Montant à régler', style: TextStyle(fontSize: 9))),
            const Center(
                child: Text('2 200 XAF',
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: _navy))),
            const SizedBox(height: 22),
            _PaymentCard('Espèces', Icons.payments_outlined, true),
            _PaymentCard('Mobile Money', Icons.phone_android_outlined, false),
            _PaymentCard('Carte', Icons.credit_card_outlined, false),
            const Spacer(),
            _PrimaryButton('Confirmer le paiement'),
          ],
        ),
      );

  static Widget _receipt() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 26),
            const Center(
                child: CircleAvatar(
                    radius: 28,
                    backgroundColor: Color(0xFFDDF7EB),
                    child: Icon(Icons.check, color: _green, size: 32))),
            const SizedBox(height: 12),
            const Center(
                child: Text('Vente réussie',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 19,
                        color: _navy))),
            const SizedBox(height: 18),
            _InfoRow('Reçu', '#4821'),
            _InfoRow('Date', '22/09/2026 · 09:41'),
            _InfoRow('Total', '2 200 XAF'),
            _InfoRow('Paiement', 'Espèces'),
            _InfoRow('Caissière', 'Amina'),
            const Spacer(),
            Row(children: [
              _OutlineButton('Partager'),
              const SizedBox(width: 8),
              Expanded(child: _PrimaryButton('Nouvelle vente'))
            ]),
          ],
        ),
      );

  static Widget _history() => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(title: 'Ventes', action: Icons.filter_list_outlined),
            _Search('Rechercher un reçu...'),
            _SaleRow(
                '#4821', '12 500 XAF', 'Mobile Money', 'Synchronisé', _green),
            _SaleRow('#4820', '3 200 XAF', 'Espèces', 'Synchronisé', _green),
            _SaleRow('#4819', '8 750 XAF', 'Carte', 'En attente', _amber),
            _SaleRow('#4818', '2 200 XAF', 'Espèces', 'Échec', _red),
          ],
        ),
      );

  static Widget _syncCenter() => _StatusScreen(
        title: 'Synchronisation',
        headline: 'Votre activité est protégée',
        color: _green,
        icon: Icons.cloud_done_outlined,
        rows: const [
          ('Synchronisé', 'Aujourd’hui à 09:41'),
          ('En attente', '2 ventes'),
          ('Échec', '0 élément'),
          ('À vérifier', '0 élément'),
        ],
      );
}

class _StoryboardScreen {
  final String title;
  final Widget Function() builder;
  const _StoryboardScreen(this.title, this.builder);
}

class _StoryboardCard extends StatelessWidget {
  final int number;
  final String title;
  final Widget child;
  const _StoryboardCard(
      {required this.number, required this.title, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(child: child),
          const SizedBox(height: 10),
          Text('$number  ·  $title',
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF17324D))),
        ],
      );
}

class _Phone extends StatelessWidget {
  final Widget child;
  final Color background;
  const _Phone({required this.child, this.background = Colors.white});

  @override
  Widget build(BuildContext context) => AspectRatio(
        aspectRatio: 0.49,
        child: Container(
          padding: const EdgeInsets.fromLTRB(14, 20, 14, 12),
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFD7E0EA)),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x140A2A43),
                  blurRadius: 12,
                  offset: Offset(0, 5))
            ],
          ),
          child: DefaultTextStyle(
            style: const TextStyle(
                fontFamily: 'Roboto', color: Color(0xFF17324D), fontSize: 9),
            child: child,
          ),
        ),
      );
}

class _BoardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('MboaPOS',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF092A4A))),
                SizedBox(height: 4),
                Text('Gérez. Vendez. Grandissez.  ·  Mobile product storyboard',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Wrap(spacing: 12, children: [
            _Legend('Bleu · action', Color(0xFF146EF5)),
            _Legend('Vert · succès', Color(0xFF16A66A)),
            _Legend('Ambre · attention', Color(0xFFF59E0B)),
          ]),
        ],
      );
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend(this.label, this.color);
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisSize: MainAxisSize.min, children: [
        CircleAvatar(radius: 4, backgroundColor: color),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ]);
}

class _Logo extends StatelessWidget {
  final bool light;
  const _Logo({this.light = false});
  @override
  Widget build(BuildContext context) =>
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.storefront, color: light ? Colors.white : _blue, size: 25),
        const SizedBox(width: 6),
        Text('MboaPOS',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: light ? Colors.white : _navy)),
      ]);
}

class _TopBar extends StatelessWidget {
  final String? title;
  final bool back;
  final IconData? action;
  const _TopBar({this.title, this.back = false, this.action});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Row(children: [
          if (back) const Icon(Icons.arrow_back_ios_new, size: 12),
          if (back) const SizedBox(width: 6),
          Expanded(
              child: Text(title ?? '',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: _navy))),
          Icon(action ?? Icons.notifications_none_outlined, size: 17),
        ]),
      );
}

class _Title extends StatelessWidget {
  final String text;
  const _Title(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 17,
          height: 1.15,
          fontWeight: FontWeight.w800,
          color: _navy));
}

class _Muted extends StatelessWidget {
  final String text;
  const _Muted(this.text);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Text(text,
          style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))));
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  const _PrimaryButton(this.label);
  @override
  Widget build(BuildContext context) => Container(
      height: 32,
      alignment: Alignment.center,
      decoration:
          BoxDecoration(color: _blue, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: const TextStyle(
              color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700)));
}

class _OutlineButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  const _OutlineButton(this.label, {this.icon, this.color = _blue});
  @override
  Widget build(BuildContext context) => Expanded(
      child: Container(
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(color: color),
              borderRadius: BorderRadius.circular(8)),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            if (icon != null) Icon(icon, color: color, size: 14),
            if (icon != null) const SizedBox(width: 3),
            Text(label,
                style: TextStyle(
                    color: color, fontSize: 8, fontWeight: FontWeight.w700))
          ])));
}

class _Link extends StatelessWidget {
  final String text;
  const _Link(this.text);
  @override
  Widget build(BuildContext context) => Center(
      child: Text(text,
          style: const TextStyle(
              color: _blue, fontSize: 9, fontWeight: FontWeight.w700)));
}

class _Field extends StatelessWidget {
  final String label;
  final IconData icon;
  final IconData? suffix;
  const _Field(this.label, this.icon, {this.suffix});
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      height: 31,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD7E0EA)),
          borderRadius: BorderRadius.circular(7)),
      child: Row(children: [
        Icon(icon, size: 13, color: const Color(0xFF64748B)),
        const SizedBox(width: 7),
        Expanded(
            child: Text(label,
                style: const TextStyle(fontSize: 8, color: Color(0xFF64748B)))),
        if (suffix != null)
          Icon(suffix, size: 13, color: const Color(0xFF64748B))
      ]));
}

class _Divider extends StatelessWidget {
  final String label;
  const _Divider(this.label);
  @override
  Widget build(BuildContext context) => Row(children: [
        const Expanded(child: Divider(height: 24)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(label,
                style: const TextStyle(fontSize: 7, color: Color(0xFF64748B)))),
        const Expanded(child: Divider(height: 24))
      ]);
}

class _Onboarding extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final int page;
  final String button;
  final String? secondary;
  final Widget? extra;
  const _Onboarding(
      {required this.title,
      required this.text,
      required this.icon,
      required this.page,
      required this.button,
      this.secondary,
      this.extra});
  @override
  Widget build(BuildContext context) => _Phone(
          child: Column(children: [
        _TopBar(),
        const SizedBox(height: 15),
        Container(
            height: 100,
            decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF), borderRadius: AppRadius.card),
            child: Icon(icon, size: 58, color: _blue)),
        const SizedBox(height: 17),
        _Title(title),
        _Muted(text),
        if (extra != null) ...[const SizedBox(height: 12), extra!],
        const Spacer(),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                3,
                (i) => Container(
                    width: i == page ? 15 : 5,
                    height: 5,
                    margin: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                        color: i == page ? _blue : const Color(0xFFD7E0EA),
                        borderRadius: BorderRadius.circular(5))))),
        const SizedBox(height: 12),
        _PrimaryButton(button),
        if (secondary != null) ...[const SizedBox(height: 9), _Link(secondary!)]
      ]));
}

class _MiniFeature extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MiniFeature(this.icon, this.text);
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(7)),
      child: Row(children: [
        Icon(icon, color: _blue, size: 15),
        const SizedBox(width: 7),
        Text(text,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700))
      ]));
}

class _FormScreen extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> fields;
  final String button;
  final String? footer;
  const _FormScreen(
      {required this.title,
      required this.fields,
      required this.button,
      this.subtitle,
      this.footer});
  @override
  Widget build(BuildContext context) => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(back: true),
            _Title(title),
            if (subtitle != null) _Muted(subtitle!),
            const SizedBox(height: 15),
            ...fields,
            const Spacer(),
            _PrimaryButton(button),
            if (footer != null) ...[
              const SizedBox(height: 8),
              Text(
                footer!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 6, color: Color(0xFF64748B)),
              ),
            ],
          ],
        ),
      );
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final bool selected;
  const _RoleCard(this.title, this.text, this.icon, this.selected);
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0F6FF) : Colors.white,
          border: Border.all(
              color: selected ? _blue : const Color(0xFFD7E0EA),
              width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(9)),
      child: Row(children: [
        CircleAvatar(
            radius: 15,
            backgroundColor:
                selected ? const Color(0xFFDCEAFF) : const Color(0xFFF4F7FB),
            child: Icon(icon, size: 15, color: _blue)),
        const SizedBox(width: 7),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w800)),
          Text(text,
              style: const TextStyle(fontSize: 7, color: Color(0xFF64748B)))
        ])),
        if (selected) const Icon(Icons.check_circle, color: _blue, size: 15)
      ]));
}

class _Dashboard extends StatelessWidget {
  final String name;
  final String role;
  final String total;
  final List<String> actions;
  final bool popular;
  const _Dashboard(
      {required this.name,
      required this.role,
      required this.total,
      required this.actions,
      required this.popular});
  @override
  Widget build(BuildContext context) => _Phone(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _TopBar(action: Icons.notifications_none_outlined),
            Text(
              'Bonjour, $name',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: _navy,
              ),
            ),
            Text(role,
                style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F6FF),
                borderRadius: AppRadius.card,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ventes du jour',
                          style: TextStyle(fontSize: 8)),
                      Text(
                        total,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                      const Text(
                        '↗  12 %',
                        style: TextStyle(
                          color: _green,
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(Icons.show_chart, color: _blue, size: 34),
                ],
              ),
            ),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 7,
              mainAxisSpacing: 7,
              physics: const NeverScrollableScrollPhysics(),
              children: actions
                  .map(
                    (a) => Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: a == 'Vendre' ? _blue : const Color(0xFFF4F7FB),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _actionIcon(a),
                            size: 17,
                            color: a == 'Vendre' ? Colors.white : _blue,
                          ),
                          const Spacer(),
                          Text(
                            a,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: a == 'Vendre' ? Colors.white : _navy,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
            if (popular) ...[
              const SizedBox(height: 14),
              const Text(
                'Produits populaires',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
              ),
              const _Product(
                'Eau minérale 0,5L',
                '500 XAF',
                '+',
                Icons.water_drop_outlined,
              ),
              const _Product(
                'Pain de mie',
                '1 200 XAF',
                '+',
                Icons.bakery_dining_outlined,
              ),
            ],
            const Spacer(),
            const _NavBar(),
          ],
        ),
      );
}

IconData _actionIcon(String label) => switch (label) {
      'Vendre' => Icons.point_of_sale_outlined,
      'Stock' || 'Mon stock' => Icons.inventory_2_outlined,
      'Rapports' => Icons.bar_chart_outlined,
      _ => Icons.people_outline
    };

class _Search extends StatelessWidget {
  final String hint;
  final bool scan;
  const _Search(this.hint, {this.scan = false});
  @override
  Widget build(BuildContext context) => Container(
      height: 30,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(7)),
      child: Row(children: [
        const Icon(Icons.search, size: 14, color: Color(0xFF64748B)),
        const SizedBox(width: 6),
        Expanded(
            child: Text(hint,
                style: const TextStyle(fontSize: 8, color: Color(0xFF64748B)))),
        if (scan) const Icon(Icons.qr_code_scanner, size: 14, color: _blue)
      ]));
}

class _Chips extends StatelessWidget {
  final List<String> labels;
  final int selected;
  const _Chips(this.labels, {required this.selected});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: labels
              .asMap()
              .entries
              .map((e) => Container(
                  margin: const EdgeInsets.only(right: 5, bottom: 9),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                  decoration: BoxDecoration(
                      color: e.key == selected ? _blue : Colors.white,
                      border: Border.all(
                          color: e.key == selected
                              ? _blue
                              : const Color(0xFFD7E0EA)),
                      borderRadius: BorderRadius.circular(14)),
                  child: Text(e.value,
                      style: TextStyle(
                          fontSize: 7,
                          color: e.key == selected ? Colors.white : _navy,
                          fontWeight: FontWeight.w700))))
              .toList()));
}

class _Product extends StatelessWidget {
  final String name;
  final String price;
  final String detail;
  final IconData icon;
  final bool warning;
  const _Product(this.name, this.price, this.detail, this.icon,
      {this.warning = false});
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE7EDF4))),
      child: Row(children: [
        Container(
            width: 29,
            height: 29,
            decoration: BoxDecoration(
                color: const Color(0xFFEAF2FF),
                borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: 15, color: _blue)),
        const SizedBox(width: 7),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700)),
          Text(price, style: const TextStyle(fontSize: 8, color: _blue)),
          if (detail.isNotEmpty)
            Text(detail,
                style: TextStyle(
                    fontSize: 7,
                    color: warning ? _amber : const Color(0xFF64748B)))
        ])),
        const Icon(Icons.add_circle_outline, color: _blue, size: 16)
      ]));
}

class _Status extends StatelessWidget {
  final String text;
  final Color color;
  const _Status(this.text, this.color);
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
          color: color.withValues(alpha: .12),
          borderRadius: BorderRadius.circular(12)),
      child: Text(text,
          style: TextStyle(
              fontSize: 8, color: color, fontWeight: FontWeight.w700)));
}

class _Price extends StatelessWidget {
  final String text;
  const _Price(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w800, color: _blue));
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Text(label,
            style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
        const Spacer(),
        Text(value,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w700))
      ]));
}

class _Summary extends StatelessWidget {
  final String label;
  final String value;
  const _Summary(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(children: [
        Text(label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w800, color: _navy))
      ]));
}

class _DateSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD7E0EA)),
          borderRadius: BorderRadius.circular(7)),
      child: const Row(children: [
        Icon(Icons.calendar_today_outlined, size: 12),
        SizedBox(width: 6),
        Text('01 sept. – 22 sept. 2026', style: TextStyle(fontSize: 8)),
        Spacer(),
        Icon(Icons.expand_more, size: 13)
      ]));
}

class _Chart extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      height: 88,
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 6),
      decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB), borderRadius: AppRadius.card),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [28, 45, 35, 62, 54, 76, 68]
              .map((height) => Container(
                  width: 13,
                  height: height.toDouble(),
                  decoration: const BoxDecoration(
                      color: _blue,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(4)))))
              .toList()));
}

class _SettingGroup extends StatelessWidget {
  final String title;
  final List<String> items;
  const _SettingGroup(this.title, this.items);
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Text(title,
                style: const TextStyle(
                    fontSize: 8, fontWeight: FontWeight.w800, color: _blue))),
        ...items.map((item) => Container(
            height: 31,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
                color: const Color(0xFFF4F7FB),
                borderRadius: BorderRadius.circular(6)),
            child: Row(children: [
              Text(item, style: const TextStyle(fontSize: 8)),
              const Spacer(),
              const Icon(Icons.chevron_right,
                  size: 14, color: Color(0xFF64748B))
            ])))
      ]);
}

class _StatusScreen extends StatelessWidget {
  final String title;
  final String headline;
  final Color color;
  final IconData icon;
  final List<(String, String)> rows;
  const _StatusScreen(
      {required this.title,
      required this.headline,
      required this.color,
      required this.icon,
      required this.rows});
  @override
  Widget build(BuildContext context) => _Phone(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        _TopBar(title: title),
        const SizedBox(height: 18),
        Center(
            child: CircleAvatar(
                radius: 29,
                backgroundColor: color.withValues(alpha: .13),
                child: Icon(icon, color: color, size: 31))),
        const SizedBox(height: 13),
        Center(
            child: Text(headline,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w800, color: _navy))),
        const SizedBox(height: 22),
        ...rows.map((row) => _InfoRow(row.$1, row.$2)),
        const Spacer(),
        _Status(
            '●  ${title == 'Mode hors connexion' ? 'Synchronisation en attente' : 'Tout est à jour'}',
            color)
      ]));
}

class _PaymentCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  const _PaymentCard(this.label, this.icon, this.selected);
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: selected ? const Color(0xFFF0F6FF) : Colors.white,
          border: Border.all(
              color: selected ? _blue : const Color(0xFFD7E0EA),
              width: selected ? 1.5 : 1),
          borderRadius: BorderRadius.circular(9)),
      child: Row(children: [
        Icon(icon, color: _blue, size: 18),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700)),
        const Spacer(),
        if (selected) const Icon(Icons.check_circle, color: _blue, size: 15)
      ]));
}

class _SaleRow extends StatelessWidget {
  final String receipt;
  final String amount;
  final String method;
  final String status;
  final Color color;
  const _SaleRow(
      this.receipt, this.amount, this.method, this.status, this.color);
  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.only(bottom: 7),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE7EDF4))),
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(receipt,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 9)),
          Text(method,
              style: const TextStyle(fontSize: 7, color: Color(0xFF64748B))),
          Text(status,
              style: TextStyle(
                  fontSize: 7, color: color, fontWeight: FontWeight.w700))
        ])),
        Text(amount,
            style: const TextStyle(
                fontSize: 9, fontWeight: FontWeight.w800, color: _navy))
      ]));
}

class _NavBar extends StatelessWidget {
  const _NavBar();

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE7EDF4)))),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Accueil', 'Ventes', 'Stock', 'Rapports', 'Plus']
              .map((label) => Column(children: [
                    Icon(_navIcon(label),
                        size: 14,
                        color: label == 'Accueil'
                            ? _blue
                            : const Color(0xFF64748B)),
                    Text(label,
                        style: TextStyle(
                            fontSize: 6,
                            color: label == 'Accueil'
                                ? _blue
                                : const Color(0xFF64748B)))
                  ]))
              .toList()));
}

IconData _navIcon(String label) => switch (label) {
      'Accueil' => Icons.home_outlined,
      'Ventes' => Icons.point_of_sale_outlined,
      'Stock' => Icons.inventory_2_outlined,
      'Rapports' => Icons.bar_chart_outlined,
      _ => Icons.more_horiz
    };

class _Fab extends StatelessWidget {
  final IconData icon;
  const _Fab(this.icon);
  @override
  Widget build(BuildContext context) => CircleAvatar(
      radius: 22,
      backgroundColor: _blue,
      child: Icon(icon, color: Colors.white));
}
