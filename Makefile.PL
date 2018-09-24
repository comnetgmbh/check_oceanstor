use 5.028000;
use ExtUtils::MakeMaker;

sub MY::postamble {
	return <<'EOF'
PAR_SUFFIX = .elf
PAR_OS = $(shell uname -s | tr A-Z a-z)
PAR_ARCH = $(shell uname -m )

par: $(foreach each,$(filter %.pl,$(TO_INST_PM)),$(subst .pl,-$(VERSION)-$(PAR_OS)-$(PAR_ARCH)$(PAR_SUFFIX),$(each)))

%-$(VERSION)-$(PAR_OS)-$(PAR_ARCH)$(PAR_SUFFIX): %.pl pm_to_blib
	pp -I blib/lib \
		$(foreach mod, \
			$(shell perl -MYAML -e 'print(join(q/ /, sort(keys(%{YAML::LoadFile(q/MYMETA.yml/)->{requires}}))). qq/\n/)'), \
			-M $(mod)::\
		) $< -o $@

EOF
}

WriteMakefile(
    NAME              => 'check_oceanstor',
    VERSION           => '1.00',
    PREREQ_PM         => {
        'Monitoring::Plugin::REST' => '1.10',
    },
    AUTHOR            => 'Rika Lena Denia <rika.denia@comnetgmbh.com>',
    LICENSE           => 'gpl_3',
);
