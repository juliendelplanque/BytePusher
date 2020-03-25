Class {
	#name : #BPNotAndBankBuilder,
	#superclass : #BPBankInitializer,
	#category : #'BytePusher-Assembler-Memory'
}

{ #category : #generating }
BPNotAndBankBuilder >> byteForAddress: anInteger [
	| x y result |
	x := (anInteger & 16rFF00) >> 8.
	y := anInteger & 16rFF.
	result := x bitAnd: y.
	1 to: 8 do: [ :i |
		result := (result bitAt: i) = 0
			ifTrue: [ result bitAt: i put: 1 ]
			ifFalse: [ result bitAt: i put: 0 ] ].
	^ result
]
