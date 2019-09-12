Class {
	#name : #BPAddZeroFlagPageBuilder,
	#superclass : #BPOpcodeBankBuilder,
	#pools : [
		'BPConstants'
	],
	#category : #'BytePusher-Assembly'
}

{ #category : #accessing }
BPAddZeroFlagPageBuilder class >> reservedMemoryZone [
	^ super reservedMemoryZone
		name: #ADD_ZERO_FLAG_PAGE;
		yourself
]

{ #category : #accessing }
BPAddZeroFlagPageBuilder class >> startAddress [
	^ 16r20000 asBPAddress
]

{ #category : #writing }
BPAddZeroFlagPageBuilder >> writeBankOn: aByteArray [
	self addressesRange do: [ :address | 
		| x y |
		x := (address & 16rFF00) >> 8.
		y := address & 16rFF.
		aByteArray
			at: address + 1 "In byte pusher, addressing starts at 0, in Pharo it starts at 1."
			put: (((x + y) % 16rFF = 0) ifTrue: [ FALSE_VALUE ] ifFalse: [ TRUE_VALUE ])	 ]
]
