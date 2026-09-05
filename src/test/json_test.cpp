#include <engine/shared/json.h>

#include <gtest/gtest.h>

TEST(Json, Escape)
{
	char aBuf[128];
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), ""), "");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), " "), " ");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "a"), "a");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\""), "\\\"");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\\"), "\\\\"); // https://www.xkcd.com/1638/
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\b"), "\\b");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\n"), "\\n");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\r"), "\\r");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\t"), "\\t");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "\x1b"), "\\u001b"); // escape
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "愛"), "愛");
	EXPECT_STREQ(EscapeJson(aBuf, sizeof(aBuf), "😂"), "😂");

	// Truncations
	EXPECT_STREQ(EscapeJson(aBuf, 2, "\\"), "");
	EXPECT_STREQ(EscapeJson(aBuf, 3, "\\"), "\\\\");
	EXPECT_STREQ(EscapeJson(aBuf, 4, "\\"), "\\\\");
	EXPECT_STREQ(EscapeJson(aBuf, 6, "\x01"), "");
	EXPECT_STREQ(EscapeJson(aBuf, 7, "\x01"), "\\u0001");
	EXPECT_STREQ(EscapeJson(aBuf, 8, "\x01"), "\\u0001");
	EXPECT_STREQ(EscapeJson(aBuf, 5, "aaaaaa"), "aaaa");
	EXPECT_STREQ(EscapeJson(aBuf, 6, "aaaaaa"), "aaaaa");
	EXPECT_STREQ(EscapeJson(aBuf, 7, "aaaaaa"), "aaaaaa");
}
