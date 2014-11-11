/*
 * PS3 Media Server, for streaming any medias to your PS3.
 * Copyright (C) 2012  Ph.Waeber
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; version 2
 * of the License only.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
package net.pms.medialibrary.commons.exceptions;

import net.pms.medialibrary.commons.enumarations.ScanState;

public class ScanStateException extends Exception{
	private static final long serialVersionUID = 1L;
	private ScanState expectedState;
	private ScanState currentState;

	public ScanStateException(ScanState expectedState, ScanState currentState){
		this(expectedState, currentState, "");
	}
	
	public ScanStateException(ScanState expectedState, ScanState currentState, String message){
		this(expectedState, currentState, "", null);
	}

	public ScanStateException(ScanState expectedState, ScanState currentState, String message, Exception innerException){
		super(message, innerException);
		this.expectedState = expectedState;
		this.currentState = currentState;
	}

	public ScanState getExpectedState() {
	    return expectedState;
	}

	public ScanState getCurrentState() {
	    return currentState;
    }
}
