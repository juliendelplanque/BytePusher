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
			package: 'BytePusher';
			package: 'BytePusher-Assembler';
			package: 'BytePusher-Assembler-GTInspectorExtensions'
				with: [ spec requires: #('BytePusher-Assembler') ];
			package: 'BytePusher-Assembler-Tests'
				with: [ spec requires: #('BytePusher-Assembler') ] ]
]
