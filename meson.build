project('dayslice-lite', 'vala', 'c')

gnome = import('gnome')

gobject = dependency('gobject-2.0')
glib = dependency('glib-2.0')
gtk = dependency('gtk+-3.0')
gio = dependency('gio-2.0')

resource_xml = files ('src/dayslice-lite.gresources.xml')
resource = gnome.compile_resources ('dayslicelite', 'src/dayslice-lite.gresources.xml', source_dir: 'src', c_name: 'dayslicelite')

dayslice_files = ['src/main.vala', 'src/appwin.vala', 'src/fsm.vala', 'src/notifier.vala', resource]

executable('dayslice-lite', dayslice_files,
    vala_args: ['--vapidir', meson.source_root(), '--pkg', 'posix', '--target-glib=2.38', '--gresources', resource_xml],
    c_args: ['-w'],
    link_args: ['-lm'],
    dependencies: [gobject, glib, gtk, gio])
