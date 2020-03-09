Class {
	#name : #BaselineOfBytePusher,
	#superclass : #BaselineOf,
	#category : #BaselineOfBytePusher
}

{ #category : #baselines }
BaselineOfBytePusher >> baseline: spec [
	<baseline>
	spec for: #common do: [ 
		spec
			package: 'BytePusher-Kernel';
			package: 'BytePusher-VM'
				with: [ spec requires: #('BytePusher-Kernel') ];
			package: 'BytePusher-Assembler'
				with: [ spec requires: #('BytePusher-Kernel') ];
			package: 'BytePusher-Assembler-GTInspectorExtensions'
				with: [ spec requires: #('BytePusher-Assembler') ];
			package: 'BytePusher-Assembler-Tests'
				with: [ spec requires: #('BytePusher-Assembler') ];
			package: 'BytePusher-VM-Debugging'
				with: [ spec requires: #('BytePusher-VM') ];
			package: 'BytePusher-VM-Debugging-Tests'
				with: [ spec requires: #('BytePusher-VM-Debugging') ] ]
]
