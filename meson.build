project('dayslice-lite', 'vala', 'c')

gnome = import('gnome')

gobject = dependency('gobject-2.0')
glib = dependency('glib-2.0')
gtk = dependency('gtk+-3.0')

resource_xml = files ('dayslicelite.gresources.xml')
resource = gnome.compile_resources ('dayslicelite', 'dayslicelite.gresources.xml', source_dir: '.', c_name: 'dayslicelite')

executable('dayslice-lite',
    'main.vala', 'appwin.vala', 'fsm.vala', resource,
    vala_args: ['--vapidir', meson.source_root(), '--pkg', 'posix', '--target-glib=2.38', '--gresources', resource_xml],
    c_args: ['-w'],
    link_args: ['-lm'],
    dependencies: [gobject, glib, gtk])
